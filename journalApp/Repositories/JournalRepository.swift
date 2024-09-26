//
//  JournalRepository.swift
//  journalApp
//
//  Created by admin on 9/5/24.
//

import Foundation
import CoreData

protocol JournalRepository {
    func create(entry: JournalEntry) throws
    func update(entry: JournalEntry) throws
    func delete(entry: JournalEntry) throws
    func fetchAll() throws -> [JournalEntry]}

