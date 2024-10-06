//
//  This file is part of the JournalApp project.
//
//  Description: Core functionality for handling journal entries, encryption, and data persistence.
//  Version: 1.0
//  Last Updated: Oct. 6, 2024
//

import Foundation
import CoreData

protocol JournalRepository {
    func create(entry: JournalEntry) throws
    func update(entry: JournalEntry) throws
    func delete(entry: JournalEntry) throws
    func fetchAll() throws -> [JournalEntry]}

