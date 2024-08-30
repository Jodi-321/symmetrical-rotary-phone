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
        container.register(SecurityManagerProtocol.self) {_ in SecurityManager()
        }
        
        //Register KeychainManager as KeychainManagerProtocol
        container.register(KeychainManagerProtocol.self) {_ in KeychainMaanger()
        }
        
        container.register(CoreDataManager.self) {_ in CoreDataManager()
        }
        
        container.register(JournalManagerProtocol.self) { resolver in
            let securityManager = resolver.resolve(SecurityManagerProtocol.self)!
            let keychainManager = resolver.resolve(KeychainManagerProtocol.self)!
            let coreDataManager = resolver.resolve(CoreDataManager.self)!
            return JournalManager(securityManager: securityManager, keychainManager: keychainManagerProtocol, coreDataManager: coreDataManager)}
        }
    
        //Register AuthenticationManager as AuthenticationManagerProtocol
        container.register(AuthenticationManagerProtocol.self) {_ in
            AuthenticationManager()
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
