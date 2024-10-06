//
//  This file is part of the JournalApp project.
//
//  Description: Core functionality for handling journal entries, encryption, and data persistence.
//  Version: 1.0
//  Last Updated: Oct. 6, 2024
//

import Foundation
import CoreData

protocol Persistable {
    associatedtype EntityType: NSManagedObject
    
    func save() throws
    func update() throws
    func delete() throws
    static func fetchAll() -> [EntityType]
}
