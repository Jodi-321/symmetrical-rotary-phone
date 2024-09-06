//
//  MoodTrackingManager.swift
//  journalApp
//
//  Created by admin on 8/30/24.
//

import Foundation

class MoodTrackingManager: MoodTrackingManagerProtocol {
    func analyzeMood(entries: [JournalEntry]) -> MoodAnalysisResult {
        let moodCounts = entries.reduce(into: [Int: Int]()) { counts, entry in
            let moodRating = Int(entry.moodRating)
            counts[moodRating, default: 0] += 1
        }
        
        let totalEntries = entries.count
        let totalMoodRating = entries.reduce(0) { $0 + Int($1.moodRating) }
        let averageMood = totalEntries > 0 ? totalMoodRating / totalEntries: 0
        
        return MoodAnalysisResult(averageMood: averageMood, moodCounts: moodCounts)
    }
}
