//
//  EncryptionKeyProviderProtocol.swift
//  journalApp
//
//  Created by admin on 8/30/24.
//

import Foundation

protocol EncryptionKeyProviderProtocol {
    func provideEncryptionKey() throws -> Data
}
