//
//  File.swift
//  Protocols
//
//  Created by admin on 8/29/24.
//

import Foundation

protocol BackupManagerProtocol {
    func createBackup() -> Result<Bool, BackupError>
    func restoreBackup() -> Result<Bool, BackupError>
}
