//
//  File.swift
//  Protocols
//
//  Created by admin on 8/29/24.
//

import Foundation

protocol SecurityManagerProtocol {
    func encrypt(data: Data) throws -> Data
    func decrypt(data: Data) throws -> Data
}
