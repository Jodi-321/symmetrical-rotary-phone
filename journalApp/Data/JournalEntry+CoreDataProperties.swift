//
//  This file is part of the JournalApp project.
//
//  Description: Core functionality for handling journal entries, encryption, and data persistence.
//  Version: 1.0
//  Last Updated: Oct. 6, 2024
//

import Foundation
import CoreData


extension JournalEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<JournalEntry> {
        return NSFetchRequest<JournalEntry>(entityName: "JournalEntry")
    }

    @NSManaged public var content: Data?
    @NSManaged public var dateCreated: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var metadata: Data?
    @NSManaged public var moodRating: Int16
    @NSManaged public var tags: NSObject?

}

extension JournalEntry : Identifiable {

}
