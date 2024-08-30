//
//  File.swift
//  Protocols
//
//  Created by admin on 8/29/24.
//

import Foundation

protocol KeychainManagerProtocol {
    func storeKey(_ key: Data, forKey keyName: String) throws
    func retrieveKey(forKey keyName: String) throws -> Data
    func deleteKey(forKey keyName: String)throws
}
