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
    let date: Date
    
    //Init from JournalEntry NSManagedObject
    init(from journalEntry: JournalEntry) {
        self.id = journalEntry.id
        self.content = journalEntry.content
        self.moodRating = Int(journalEntry.moodRating)
        self.date = journalEntry.date
    }
    
    //Convert back to JournalEntry NSManagedObject
    func toJournalEntry(context: NSManagedObjectContext) -> JournalEntry {
        let entry = JournalEntry(context: context)
        entry.id = self.id
        entry.content = self.content //Assings data directly
        entry.moodRating = Int16(self.moodRating)
        entry.date = self.date
        return entry
    }
    
    //Helper method to convert content to a readable string
    func contentAsString() -> String? {
        return String(data: content, encoding: .utf8)
    }
    
    //Helper method to create a JournalEntryData from a String for content
    static func fromStringContent(id: UUID, content: String, moodRating: Int, date: Date) -> JournalEntryData? {
        guard let dataContent = content.data(using: .utf8) else { return nil}
        return JournalEntryData(id: id, content: dataContent, moodRating: moodRating, date: date)
    }
    
    //explixit init for creating JournalEntryData with Data content
    init(id: UUID, content: Data, moodRating: Int, date: Date) {
        self.id = id
        self.content = content
        self.moodRating = moodRating
        self.date = date
    }
}
