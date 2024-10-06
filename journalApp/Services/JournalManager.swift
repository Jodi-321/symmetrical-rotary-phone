//
//  This file is part of the JournalApp project.
//
//  Description: Core functionality for handling journal entries, encryption, and data persistence.
//  Version: 1.0
//  Last Updated: Oct. 6, 2024
//

import Foundation
import CoreData

// JournalManager class handling CRUD operations and validations
class JournalManager: JournalManagerProtocol {
    private let securityManager: SecurityManagerProtocol
    private let keychainManager: KeychainManagerProtocol
    //private let coreDataManager: CoreDataManager
    //private let metadataValidator: MetadataValidator
    
    init(securityManager: SecurityManagerProtocol, keychainManager: KeychainManagerProtocol /*, coreDataManager: CoreDataManager */ ) {
        self.securityManager = securityManager
        self.keychainManager = keychainManager
        //self.coreDataManager = coreDataManager
        //self.metadataValidator = MetadataValidator()
    }
    
    // Create new journal entry
    func createEntry(content: String, moodRating: Int, completion: @escaping (Result<JournalEntry, JournalError>) -> Void){
        do {
            // Validatr content
            guard !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                completion(.failure(.dataIntegrityError("Content cannot be empty.")))
                return
            }

            
            //validate moodRating
            guard (1...5).contains(moodRating) else {
                completion(.failure(.dataIntegrityError("Mood rating must be between 1 and 5.")))
                return
            }
            
            
            do{
                //Encrypt content string to Data
                let encryptedContent = try securityManager.encrypt(data: Data(content.utf8))
                
                //Using background context for data operations to avoid blocking main thread
                //let context = coreDataManager.persistentContainer.newBackgroundContext()
                CoreDataStack.shared.performOnBackgroundContext { [weak self] context in
                    guard let self = self else { return } // Capture self weakly ro avoid retain cycles
                    
                    do {
                        //Create new JournalEntry object
                        let newEntry = JournalEntry(context: context)
                        newEntry.id = UUID()
                        newEntry.content = encryptedContent
                        newEntry.moodRating = Int16(moodRating)
                        newEntry.dateCreated = Date()
                        
                        // Save context
                        try CoreDataStack.shared.saveContext(context)
                        
                        // Fetch the entry in the main context to return
                        let mainContext = CoreDataStack.shared.mainContext
                        let mainEntry = mainContext.object(with: newEntry.objectID) as? JournalEntry
                        
                        DispatchQueue.main.async {
                            if let mainEntry = mainEntry {
                                completion(.success(mainEntry))
                            } else {
                                completion(.failure(.coreDataError("Failed to retrieve entry in main context.")))
                                return
                            }
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion(.failure(.coreDataError(error.localizedDescription)))
                        }
                    }
                }
            } catch {
                completion(.failure(.encryptionError(error.localizedDescription)))
                return
            }
        }
    }
        
        
        //Pull all journal entries with decryption
    func fetchEntries(completion: @escaping (Result<[JournalEntry], JournalError>) -> Void) {
        //var fetchedEntries: [JournalEntry] = []
        CoreDataStack.shared.performOnMainContext { [weak self] context in
            guard let self = self else { return }
            
            let request: NSFetchRequest<JournalEntry> = JournalEntry.fetchRequest()
            do {
                let entries = try context.fetch(request)
                var decryptedEntries: [JournalEntry] = []
                for entry in entries {
                    // Ensure 'content' is not nil before decryption
                    guard let encryptedContent = entry.content else {
                        print("Content is missing for entry \(String(describing: entry.id))")
                        continue
                    }
                    
                    do {
                        // Decrypt the content
                        let decryptedContent = try self.securityManager.decrypt(data: encryptedContent)
                        entry.content = decryptedContent // Sets decrypted content back
                        decryptedEntries.append(entry)
                    } catch {
                        print("Failed to decrypt content for entry \(String(describing: entry.id)):\(error)")
                    }
                }
                completion(.success(decryptedEntries))
            } catch {
                completion(.failure(.coreDataError(error.localizedDescription)))
            }
        }
    }
        
        
    //Update existing journal entry
    func updateEntry(entry: JournalEntry, updatedContent: String, updatedMoodRating: Int, completion: @escaping (Result<Bool, JournalError>) -> Void) {
        //CoreDataStack.shared.performOnBackgroundContext { [weak self] context in
        guard !updatedContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            //guard let self = self else { return }
            completion(.failure(.dataIntegrityError("Content cannot be empty.")))
            return
        }
        // Validate updated moodRating
        guard(1...5).contains(updatedMoodRating) else {
            completion(.failure(.dataIntegrityError("Mood rating must be between 1 and 5.")))
            return
        }
        
        do {
            //Encrypt content data
            let encryptedContent = try securityManager.encrypt(data: Data(updatedContent.utf8))
            
            CoreDataStack.shared.performOnBackgroundContext { [weak self] context in
                guard let self = self else {return}
                do {
                    // Fetgch the entry in the background context
                    let backgroundEntry = context.object(with: entry.objectID) as! JournalEntry
                    backgroundEntry.content = encryptedContent
                    backgroundEntry.moodRating = Int16(updatedMoodRating)
                    
                    //entry.content = try securityManager.encrypt(data: Data(updatedContent.utf8))
                    //entry.moodRating = Int16(updatedMoodRating)
                    
                    // Save context
                    try CoreDataStack.shared.saveContext(context)
                    
                    DispatchQueue.main.async {
                        completion(.success(true))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(.coreDataError(error.localizedDescription)))
                    }
                }
            }
        } catch {
            completion(.failure(.encryptionError(error.localizedDescription)))
        }
    }
        
    //Delete journal entry
    func deleteEntry(entry: JournalEntry, completion: @escaping (Result<Bool, JournalError>) -> Void) {
        CoreDataStack.shared.performOnBackgroundContext { context in
            do {
                let backgroundEntry = context.object(with: entry.objectID)
                context.delete(backgroundEntry)
                try context.save()
                    
                DispatchQueue.main.async {
                    completion(.success(true))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.coreDataError(error.localizedDescription)))
                }
            }
        }
    }
}

