//
//  MetadataValidatable.swift
//  journalApp
//
//  Created by admin on 9/5/24.
//

import Foundation

protocol MetadataValidatable {
    func validateMetadata(_ metadata: [String: Any]) throws
}
