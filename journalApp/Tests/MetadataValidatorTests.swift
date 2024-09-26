//
//  MetadataValidatorTests.swift
//  journalApp
//
//  Created by admin on 9/4/24.
//

/*
 
 import Foundation
 @testable import journalApp
 import XCTest
 
 class MetadataValidatorTests: XCTestCase {
 let validator = MetadataValidator()
 
 func testValidMetadata(){
 
 let validMoodMetadata: [String: Any] = ["mood":5]
 XCTAssertNoThrow(try validator.validate(metadata: validMoodMetadata), "Valid mood metadata should not throw an error.")
 
 //Valid string metadata for 'location'
 let validLocationMetadata: [String: Any] = ["location": "Home"]
 XCTAssertNoThrow(try validator.validate(metadata: validLocationMetadata), "Valid location metadata should not throw an error.")
 
 // Valid string array metadata for 'tags'
 let validTagsMetadata: [String: Any] = ["tags":["personal", "daily"]]
 XCTAssertNoThrow(try validator.validate(metadata: validTagsMetadata), "Valid tags metadata should not throw an error.")
 
 //Valid mixed metadata
 let validMixedMetadata: [String: Any] = [
 "mood":4,
 "tags":["work","stress"],
 "location": "Office"
 ]
 XCTAssertNoThrow(try validator.validate(metadata: validMixedMetadata), "Valid mixed metadata should not throw an error.")
 }
 
 func testInvalidMetadataKey() {
 //let validator = MetadataValidator()
 let invalidMetadata: [String: Any] = ["invalidKey": "value"]
 
 XCTAssertThrowsError(try validator.validate(metadata: invalidMetadata)) { error in
 XCTAssertEqual(error as? MetadataValidationError,MetadataValidationError.invalidKey, "Invalid key should throw an 'invalidKey' error.")
 }
 }
 
 func testInvalidMetadataType() {
 //let validator = MetadataValidator()
 
 //Invalid type for 'mood' (should be Int)
 let invalidMoodMetadata: [String: Any] = ["mood":"happy"]
 XCTAssertThrowsError(try validator.validate(metadata: invalidMoodMetadata)) { error in
 XCTAssertEqual(error as? MetadataValidationError, MetadataValidationError.invalidType, "Invalid type for 'mood' should throw an 'invalidType' error.")
 }
 
 // Invalid type for 'location' (should be String)
 let invalidLocationMetadata: [String: Any] = ["location": 123]
 XCTAssertThrowsError(try validator.validate(metadata: invalidLocationMetadata)) { error in
 XCTAssertEqual(error as? MetadataValidationError, MetadataValidationError.invalidType, "Invalid type for 'location' should throw an 'invalidType' error.")
 }
 
 // Invalid type for 'tags' (should be [String])
 let invalidTagsMetadata: [String: Any] = ["tags":"notAnArray"]
 XCTAssertThrowsError(try validator.validate(metadata: invalidTagsMetadata)) { error in
 XCTAssertEqual(error as? MetadataValidationError, MetadataValidationError.invalidType, "Invalid type for 'tags' should throw an 'invalidType' error.")
 }
 }
 
 func testMixedValidAndInvalidMetadata() {
 //let validator = MetadataValidator()
 
 //Mix of valid and incvalid metadata
 let mixedMetadata: [String: Any] = [
 "mood":3,                   // valid
 "tags": "shouldBeArray",    // invalid
 "location": 123             // invalid
 ]
 
 XCTAssertThrowsError(try validator.validate(metadata: mixedMetadata)) { error in
 XCTAssertEqual(error as? MetadataValidationError, MetadataValidationError.invalidType, "Mixed valid and invalid metadata should throw an 'invalidType' error for the first invalid entry.")
 }
 }
 
 func testEmptyMetadata() {
 let emptyMetada: [String: Any] = [:]
 XCTAssertNoThrow(try validator.validate(metadata: emptyMetada), "Empty metadata should not throw an error.")
 }
 
 }
 
 /*
  class MetadataKeyRegistryTests: XCTestCase {
  
  func testValidKeysInRegistry() {
  XCTAssertTrue(MetadataKeyRegistry.shared.isKeyAllowed("mood"), "Mood should be an allowed key.")
  XCTAssertTrue(MetadataKeyRegistry.shared.isKeyAllowed("tags"), "Tags should be an allowed key.")
  XCTAssertTrue(MetadataKeyRegistry.shared.isKeyAllowed("location"), "Location should be an allowed key.")
  XCTAssertFalse(MetadataKeyRegistry.shared.isKeyAllowed("invalidKey"), "InvalidKey should not be allowed key.")
  }
  
  func testTypeForKeyInRegistry() {
  XCTAssertEqual(MetadataKeyRegistry.shared.typeForKey("mood"), .integer, "Mood key should expect an integer value.")
  XCTAssertEqual(MetadataKeyRegistry.shared.typeForKey("tags"), .stringArray, "Tags key should expect a string array value.")
  XCTAssertEqual(MetadataKeyRegistry.shared.typeForKey("location"), .string, "Location key should expect a string value.")
  XCTAssertNil(MetadataKeyRegistry.shared.typeForKey("invalidKey"), "Invalid key should return nil for type.")
  }
  }
  */
 
 */
