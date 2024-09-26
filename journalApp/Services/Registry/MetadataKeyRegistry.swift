//
//  MetadataKeyRegistry.swift
//  journalApp
//
//  Created by admin on 9/5/24.
//

/*
 

import Foundation

class MetadataKeyRegistry {
    static let shared = MetadataKeyRegistry()
    
    // Enumeration for metadata types
    enum MetadataType {
        case string
        case integer
        case stringArray
        case date
        //Add more metadata keys as needed
    }

//struct MetadataKeyRegistry {
    
    // Dictionary to store allowed keys and their types
    private(set) var allowedKeys: [String: MetadataType] = [
        "mood": .integer,
        "location": .string,
        "tags": .stringArray,
        "createdDate": .date,
        "weather": .string
    ]
    
    //Func to check if key is allowed
    func isKeyAllowed(_ key: String) -> Bool {
        return allowedKeys.keys.contains(key)
    }
    
    // Func to get the type of metadata for a key
    func typeForKey(_ key: String) -> MetadataType? {
        return allowedKeys[key]
    }
    
    
    //Private init to enforce singleton pattern
    private init() {}
}

*/
