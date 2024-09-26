//
//  JournalEntry+CoreDataProperties.swift
//  journalApp
//
//  Created by admin on 9/7/24.
//
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
