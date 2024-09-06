//
//  MoodAnalysisResult.swift
//  journalApp
//
//  Created by admin on 8/30/24.
//

import Foundation

struct MoodAnalysisResult {
    let averageMood: Int
    let moodCounts: [Int: Int] //dictionary with mood ratings as keys and counts as values
}
