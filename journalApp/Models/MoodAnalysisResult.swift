//
//  This file is part of the JournalApp project.
//
//  Description: Core functionality for handling journal entries, encryption, and data persistence.
//  Version: 1.0
//  Last Updated: Oct. 6, 2024
//

import Foundation

struct MoodAnalysisResult {
    let averageMood: Int
    let moodCounts: [Int: Int] //dictionary with mood ratings as keys and counts as values
}
