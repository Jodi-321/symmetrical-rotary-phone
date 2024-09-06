//
//  Persistable.swift
//  journalApp
//
//  Created by admin on 9/5/24.
//

import Foundation
import CoreData

protocol Persistable {
    associatedtype EntityType: NSManagedObject
    
    func save() throws
    func update() throws
    func delete() throws
    static func fetchAll() -> [EntityType]
}
