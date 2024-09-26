//
//  BackupManager.swift
//  journalApp
//
//  Created by admin on 8/30/24.
//

import Foundation
import CoreData

class BackupManager: BackupManagerProtocol {
    private let fileManager = FileManager.default
    private let backupFileName = "JournalBackup.json"
    
    //create backup of journal entries
    func createBackup() -> Result<Bool, BackupError> {
        let entries = CoreDataStack.shared.fetchAllEntries()
        
        // Convert JournalEntry objects to JournalEntryData
        let entriesData = entries.map { JournalEntryData(from: $0) }
        
        do {
            let jsonData = try JSONEncoder().encode(entriesData)
            let backupURL = getBackupURL()
            try jsonData.write(to: backupURL)
            return .success(true)
        } catch {
            return .failure(.backupFailed(error.localizedDescription))
        }
    }
    
    //Restore journal entries from a backup
    func restoreBackup() -> Result<Bool, BackupError> {
        let backupURL = getBackupURL()
        do {
            let jsonData = try Data(contentsOf: backupURL)
            let restoredEntriesData = try JSONDecoder().decode([JournalEntryData].self, from: jsonData)
            
            let restoredEntries = restoredEntriesData.map { $0.toJournalEntry(context: CoreDataStack.shared.mainContext)}
            CoreDataStack.shared.save(entries: restoredEntries)
            
            return .success(true)
        } catch {
                return .failure(.restoreFailed(error.localizedDescription))
        }
    }
                                                           
    //Helper function to get the backup file URL
    private func getBackupURL() -> URL {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(backupFileName)
    }
}
