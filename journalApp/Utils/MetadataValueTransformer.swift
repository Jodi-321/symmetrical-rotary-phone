//
//  This file is part of the JournalApp project.
//
//  Description: Core functionality for handling journal entries, encryption, and data persistence.
//  Version: 1.0
//  Last Updated: Oct. 6, 2024
//

/*
import Foundation
import CoreData

@objc(MetadataValueTransformer)
class MetadataValueTransformer: ValueTransformer {
    //Method to convert the metadata dictionary to binary data for secure storage
    override func transformedValue(_ value: Any?) -> Any? {
        guard let metadata = value as? [String: Any] else {return nil}
        
        do {
            //Serialize dictionary to JSON data
            let jsonData = try JSONSerialization.data(withJSONObject: metadata, options: [])
            return jsonData
        } catch {
            print("Error serializing metadata to JSON: \(error.localizedDescription)")
            return nil
        }
    }
    
    // Method to convert binary data back into a metadata dictionary for use in the app
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil}
        
        do {
            // Deserialize JSON data to dictionary
            let metadata = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            return metadata
        } catch {
            print("Error deserializing JSON to metadata: \(error.localizedDescription)")
            return nil
        }
    }
    
    // Register the value transformer with Core Data
    static func register() {
        let transformerName = NSValueTransformerName("MetadataValueTransformer")
        let transformer = MetadataValueTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: transformerName)
    }
}
*/
