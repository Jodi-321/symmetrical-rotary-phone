//
//  JournalEntryData.swift
//  journalApp
//
//  Created by admin on 8/30/24.
//

import Foundation
import CoreData

struct JournalEntryData: Codable {
    let id: UUID
    let content: Data
    let moodRating: Int
    let dateCreated: Date
    
    //Init from JournalEntry NSManagedObject
    init(from journalEntry: JournalEntry) {
        self.id = journalEntry.value(forKey: "id") as! UUID
        self.content = journalEntry.value(forKey: "content") as! Data
        self.moodRating = journalEntry.value(forKey: "moodRating") as! Int
        self.dateCreated = journalEntry.value(forKey: "dateCreated") as! Date
    }
    
    //Convert back to JournalEntry NSManagedObject
    func toJournalEntry(context: NSManagedObjectContext) -> JournalEntry {
        let entry = JournalEntry(context: context)
        entry.setValue(self.id, forKey: "id")
        entry.setValue(self.content, forKey: "content")//Assings data directly
        entry.setValue(Int16(self.moodRating), forKey: "moodRating")
        entry.setValue(self.dateCreated, forKey: "dateCreated")
        return entry
    }
    
    //Helper method to convert content to a readable string
    func contentAsString() -> String? {
        return String(data: content, encoding: .utf8)
    }
    
    //Helper method to create a JournalEntryData from a String for content
    static func fromStringContent(id: UUID, content: String, moodRating: Int, dateCreated: Date) -> JournalEntryData? {
        guard let dataContent = content.data(using: .utf8) else { return nil}
        return JournalEntryData(id: id, content: dataContent, moodRating: moodRating, dateCreated: dateCreated)
    }
    
    //explixit init for creating JournalEntryData with Data content
    init(id: UUID, content: Data, moodRating: Int, dateCreated: Date) {
        self.id = id
        self.content = content
        self.moodRating = moodRating
        self.dateCreated = dateCreated
    }
}
