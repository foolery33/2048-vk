//
//  ScoreManager.swift
//  2048-vk
//
//  Created by admin on 08.05.2023.
//

import Foundation

final class ScoreManagerImplementation: ScoreManagerRepository {
    
    enum CodingKeys {
        static var currentScore = "currentScore"
        static var highestScore = "highestScore"
    }
    
    func fetchCurrentScore() -> Int {
        return UserDefaults.standard.integer(forKey: CodingKeys.currentScore)
    }
    func fetchHighestScore() -> Int {
        return UserDefaults.standard.integer(forKey: CodingKeys.highestScore)
    }
    
    func saveCurrentScore(_ score: Int) {
        UserDefaults.standard.set(score, forKey: CodingKeys.currentScore)
    }
    func saveHighestScore(_ score: Int) {
        if score > fetchHighestScore() {
            UserDefaults.standard.set(score, forKey: CodingKeys.highestScore)
        }
    }
    
}
