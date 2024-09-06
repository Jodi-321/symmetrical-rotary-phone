//
//  JournalEntryValidationTests.swift
//  journalApp
//
//  Created by admin on 9/4/24.
//

import Foundation
@testable import journalApp
import XCTest

class JournalEntryValidationTests : XCTestCase {
    func testValidEntry() {
        let entry = JournalEntry(context: CoreDataManager.shared.context)
        entry.content = "Valid content".data(using: .utf8)!
        entry.moodRating = 3
        
        do {
            try entry.validateEntry()
            XCTAssertTrue(true, "Entry is valid.")
        } catch {
            XCTFail("Entry validation failed: \(error)")
        }
    }
    
    func testEmptyContent() {
        let entry = JournalEntry(context: CoreDataManager.shared.context)
        entry.content = "".data(using: .utf8)!
        entry.moodRating = 3
        
        XCTAssertThrowsError(try entry.validateContent()) {
            error in XCTAssertEqual(error as? JournalError, JournalError.dataIntegrityError("Content cannot be empty."))
        }
    }
    
    func testInvalidMoodRating() {
        let entry = JournalEntry(context: CoreDataManager.shared.context)
        entry.content = "Valid content".data(using: .utf8)!
        entry.moodRating = 6
        
        XCTAssertThrowsError(try entry.validateMoodRating()) { error in XCTAssertEqual(error as? JournalError, JournalError.dataIntegrityError("Mood rating must be between 1 and 5."))
        }
    }
    
    func testInvalidMetadata() {
        let validator = MetadataValidator()
        let invalidMetadata: [String: Any] = ["invalidKey": "value"]
        
        XCTAssertThrowsError(try validator.validate(metadata: invalidMetadata)) { error in
            XCTAssertEqual(error as? MetadataValidationError, MetadataValidationError.invalidKey)}
    }
}
