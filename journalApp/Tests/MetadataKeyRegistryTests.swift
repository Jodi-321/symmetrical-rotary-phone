//
//  MetadataKeyRegistryTests.swift
//  journalApp
//
//  Created by admin on 9/4/24.
//

import Foundation
@testable import journalApp
import XCTest

class MetadataKeyRegistryTests: XCTestCase {
    func testAllowedKeys() {
        //Ensure all expected keys are allowed
        XCTAssertTrue(MetadataKeyRegistry.shared.isKeyAllowed("mood"), "Key 'mood' should be allowed.")
        XCTAssertTrue(MetadataKeyRegistry.shared.isKeyAllowed("tags"), "Key 'tags' should be allowed.")
        XCTAssertTrue(MetadataKeyRegistry.shared.isKeyAllowed("location"), "Key 'location' should be allowed.")
        XCTAssertTrue(MetadataKeyRegistry.shared.isKeyAllowed("weather"), "Key 'weather' should be allowed.")
        
        //Test an invalid key
        XCTAssertFalse(MetadataKeyRegistry.shared.isKeyAllowed("invalidKey"), "Key 'invalidKey' should not be allowed")
    }
    
    func testTypeForKey() {
        //Ensure the type returned for each key is correct
        XCTAssertEqual(MetadataKeyRegistry.shared.typeForKey("mood"), .integer, "Key 'mood' should have type 'integer'.")
        XCTAssertEqual(MetadataKeyRegistry.shared.typeForKey("tags"), .stringArray, "Key 'tags' should have type 'stringArray'.")
        XCTAssertEqual(MetadataKeyRegistry.shared.typeForKey("location"), .string, "Key 'location' should have type 'string'.")
        XCTAssertEqual(MetadataKeyRegistry.shared.typeForKey("weather"), .string, "Key 'weather' should have type 'string'.")
        
        //Test for non-existing key
        XCTAssertNil(MetadataKeyRegistry.shared.typeForKey("invalidKey"), "Type for key 'invalidKey' should be nil.")
    }
}
