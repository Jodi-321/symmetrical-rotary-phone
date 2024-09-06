//
//  File.swift
//  DI
//
//  Created by admin on 8/29/24.
//

import Foundation
import Swinject

class DIContainer {
    static let shared = DIContainer() // Singleton instance
    let container: Container //Swinject container
    
    private init() {
        container = Container()
        
        // Register all dependencies
        registerDependencies()
    }
    
    private func registerDependencies() {
        //Register SecurityManager as SecurityManagerProtocol
        container.register(SecurityManagerProtocol.self) { resolver in
            let encryptionKeyProvider = resolver.resolve(EncryptionKeyProviderProtocol.self)!
            return SecurityManager(encryptionKeyProvider: encryptionKeyProvider)
        }
        
        //Register KeychainManager as KeychainManagerProtocol
        container.register(KeychainManagerProtocol.self) {_ in KeychainManager()
        }
        
        container.register(EncryptionKeyProviderProtocol.self) {resolver in
            let keychainManager = resolver.resolve(KeychainManagerProtocol.self)!
            return EncryptionKeyProvider(keychainManager: keychainManager)
        }
        
        /*
         container.register(SecurityManagerProtocol.self) { resolver in
         let encryptionKeyProvider = resolver.resolve(EncryptionKeyProviderProtocol.self)!
         return EncryptionKeyProvider(keychainManager: KeychainManager)
         }
         */
        
        container.register(CoreDataManager.self) {_ in CoreDataManager.shared
        }
        
        container.register(JournalManagerProtocol.self) { resolver in
            let securityManager = resolver.resolve(SecurityManagerProtocol.self)!
            let keychainManager = resolver.resolve(KeychainManagerProtocol.self)!
            let coreDataManager = resolver.resolve(CoreDataManager.self)!
            return JournalManager(securityManager: securityManager, keychainManager: keychainManager, coreDataManager: coreDataManager)}
        
        
        //Register AuthenticationManager as AuthenticationManagerProtocol
        container.register(AuthenticationManagerProtocol.self) { resolver in
            let keychainManager = resolver.resolve(KeychainManagerProtocol.self)!
            return AuthenticationManager(keychainManager: keychainManager)
        }
        
        container.register(AnalyticsManagerProtocol.self) {_ in
            AnalyticsManager()
        }
        
        container.register(BackupManagerProtocol.self) {_ in
            BackupManager()
        }
        
        container.register(MoodTrackingManagerProtocol.self) {_ in
            MoodTrackingManager()
        }
    }

    func resolve<T>(_ type: T.Type) -> T? {
        return container.resolve(type)
    }
}
//}
