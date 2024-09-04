//
//  File.swift
//  Protocols
//
//  Created by admin on 8/29/24.
//

import Foundation

protocol MoodTrackingManagerProtocol {
    func analyzeMood(entries: [JournalEntry]) -> MoodAnalysisResult
}
