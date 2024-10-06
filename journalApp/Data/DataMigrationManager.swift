//
//  This file is part of the JournalApp project.
//
//  Description: Core functionality for handling journal entries, encryption, and data persistence.
//  Version: 1.0
//  Last Updated: Oct. 6, 2024
//

import Foundation
import CoreData
import UIKit

enum MigrationError: Error {
    case criticalError(message: String)
    case warning(message: String)
}

class DataMigrationManager {
    // SIngleton instance
    static let shared = DataMigrationManager()
    
    // Core properties
    private var persistentStoreURL: URL?
    private var sourceModel: NSManagedObjectModel?
    private var destinationModel: NSManagedObjectModel?
    private var mappingModel: NSMappingModel?
    
    // State maangement properties
    private var migrationProgress: Float = 0.0
    private var currentVersion: String = "JournalAppModelV2"  //Update this based on App's initial model version
    private var migrationCheckpoints: [String] = []
    
    // Error handling
    private var errors: [MigrationError] = []
    
    // Initializer
    private init() {
        self.persistentStoreURL = CoreDataStack.persistentStoreDescriptions.first? .url
        self.sourceModel = self.loadManagedObjectModel(version: self.currentVersion)
        self.destinationModel = CoreDataStack.managedObjectModel // Current model in use
        self.mappingModel = self.loadMappingModel(from: self.sourceModel, to: self.destinationModel)
    }
    
    // Centralized Error Handling Method
    private func handleError(_ error: MigrationError) {
        self.errors.append(error)
        
        // Log error to console
        switch error {
        case .criticalError(let message):
            print("CRITICAL ERROR: \(message)")
            logError("CRITICAL Error: \(message)")
            notifyUser(WithMessage: "A critical error occurred: \(message). Please restart the app or contact support.")
        case .warning(let message):
            print("WARNING: \(message)")
            logError("WARNING: \(message)")
        }
    }
    
    // Method to log errors to a persistent file
    private func logError(_ message: String) {
        let logMessage = "\(Date()): \(message)\n"
        
        // Save log file to a file in the app directory
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let logFileURL = documentsDirectory.appendingPathComponent("migration_log.txt")
            
            do {
                // Append to log file if it exists, otherwise create it
                if FileManager.default.fileExists(atPath: logFileURL.path) {
                    let fileHandle = try FileHandle(forWritingTo: logFileURL)
                    fileHandle.seekToEndOfFile()
                    if let data = logMessage.data(using: .utf8) {
                        fileHandle.write(data)
                    }
                    fileHandle.closeFile()
                } else {
                    try logMessage.write(to: logFileURL, atomically: true, encoding: .utf8)
                }
            } catch {
                print("Failed to write log: \(error.localizedDescription)")
            }
        }
    }
    
    // Show user-facing error notifications
    private func notifyUser(WithMessage message: String) {
        DispatchQueue.main.async {
            if let rootVC = UIApplication.shared.windows.first?.rootViewController {
                let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                rootVC.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    // Load the maanged object model for a specific version
    private func loadManagedObjectModel(version: String) -> NSManagedObjectModel? {
        guard let modelURL = Bundle.main.url(forResource: version, withExtension: "momd") else {
            print("Failed to find model URL for version \(version)")
            return nil
        }
        return NSManagedObjectModel(contentsOf: modelURL)
    }
    
    // Load the mapping model between two versions
    private func loadMappingModel(from sourceModel: NSManagedObjectModel?, to destinationModel:NSManagedObjectModel?) -> NSMappingModel? {
        guard let sourceModel = sourceModel, let destinationModel = destinationModel else {return nil}
        
        do {
            return try NSMappingModel.inferredMappingModel(forSourceModel: sourceModel, destinationModel:destinationModel)
        } catch {
            print("Failed to infer mapping model: \(error.localizedDescription)")
            return nil
        }
    }
    
    // Migration Lifecycle Management
    func performMigrationIfNeeded() {
        guard let storeURL = self.persistentStoreURL,
              let sourceModel = self.sourceModel,
              let destinationModel = self.destinationModel else {
            print("Migration prerequisites are not met.")
            return
        }
        
        if self.isMigrationNeeded(storeURL: storeURL, sourceModel: sourceModel) {
            print("Migration needed from\(self.currentVersion) to the latest version.")
            self.migrateStore(at: storeURL, fromModel: sourceModel, toModel: destinationModel)
        } else {
            print("No migration is needed.")
        }
    }
    
    // Check if migration is needed
    private func isMigrationNeeded(storeURL: URL, sourceModel: NSManagedObjectModel) -> Bool {
        guard let metadata = try? NSPersistentStoreCoordinator.metadataForPersistentStore(ofType: NSSQLiteStoreType,
                                                                                          at: storeURL) else {
            return false
        }
        return !sourceModel.isConfiguration(withName: nil, compatibleWithStoreMetadata: metadata)
    }
    
    // Perform migration
    private func migrateStore(at storeURL: URL, fromModel: NSManagedObjectModel, toModel:NSManagedObjectModel) {
        do {
            let migrationManager = NSMigrationManager(sourceModel: fromModel, destinationModel: toModel)
            let tempStoreURL = storeURL.deletingLastPathComponent().appendingPathComponent("Temp.sqlite")
            
            if let mappingModel = self.mappingModel {
                // Start Migration
                print("Starting migration...")
                try migrationManager.migrateStore(from: storeURL, sourceType: NSSQLiteStoreType, options: nil, with:
                                                    mappingModel, toDestinationURL: tempStoreURL, destinationType: NSSQLiteStoreType, destinationOptions: nil)
                
                // Replace original store with migrated store
                try FileManager.default.replaceItemAt(storeURL, withItemAt: tempStoreURL)
                print("Migration successful.")
                
                //Update the checkpoint
                self.updateCheckpoint()
                
            } else {
                print("Mapping model not found.")
                handleError(.criticalError(message: "Mapping model not found."))
            }
        } catch {
            print("Migration failed: \(error.localizedDescription)")
            handleError(.criticalError(message: "Migration failed: \(error.localizedDescription)"))
            self.rollbackMigration(storeURL: storeURL)
        }
    }
    
    // Rollback migration to the last checkpoint
    private func rollbackMigration(storeURL: URL) {
        print("Rolling back migration to the last known good checkpoint.")
        
        //Rollback logic to restore from backup or last succesful migration state
        guard let backupURL = self.createBackup(of: storeURL) else {
            print("Unable to create a backup for rollback.")
            return
        }
        restoreFromBackup(backupURL, to: storeURL)
    }
    
    // Update migration checkpoint
    private func updateCheckpoint() {
        print("Updating checkpoin...")
        migrationCheckpoints.append(currentVersion)
        // Update currentVersion to the next version if needed
    }
    
    //Backup and Restore Methods
    private func createBackup(of storeURL: URL) -> URL? {
        let backupURL = storeURL.deletingLastPathComponent().appendingPathComponent("Backup.sqlite")
        
        do {
            // Remove any existing backup
            if FileManager.default.fileExists(atPath: backupURL.path) {
                try FileManager.default.removeItem(at: backupURL)
            }
            
            // Copy the current store to the backup location
            try FileManager.default.copyItem(at: storeURL, to:backupURL)
            print("Backup created succesfully at \(backupURL.path)")
            return backupURL
        } catch {
            print("Failed to create backup: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func restoreFromBackup(_ backupURL: URL, to storeURL: URL) {
        do {
            // Remove the corrupted store
            if FileManager.default.fileExists(atPath: storeURL.path) {
                try FileManager.default.removeItem(at: storeURL)
            }
            
            // Restore the store from the backup
            try FileManager.default.copyItem(at: backupURL, to: storeURL)
            print("Restored from backup succesfully.")
        } catch {
            print("Failed to restore from backup: \(error.localizedDescription)")
            handleError(.criticalError(message: "Failed to restore from backup: \(error.localizedDescription)"))
        }
    }
    
    //Method to wrap migration transactions
    private func performDataTransformationV1ToV2() {
        let context = CoreDataStack.shared.backgroundContext
        context().performAndWait {
            let batchUpdate = NSBatchUpdateRequest(entityName: "JournalEntry")
            batchUpdate.propertiesToUpdate = ["tags": []] // init new 'tags' field
            batchUpdate.resultType = .updatedObjectsCountResultType
            
            do {
                let result = try context().execute(batchUpdate) as! NSBatchUpdateResult
                print("Batch update completed, \(result.result ?? 0) records updated.")
                try context().save()
            } catch {
                print("Error during V1 to V2 migration: \(error.localizedDescription)")
                handleError(.criticalError(message: "Error during V1 to V2 migration: \(error.localizedDescription)"))
                rollbackMigration(storeURL: persistentStoreURL!)
            }
        }
    }
}
