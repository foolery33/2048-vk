//
//  ScoreManagerRepository.swift
//  2048-vk
//
//  Created by admin on 09.05.2023.
//

import Foundation

protocol ScoreManagerRepository {
    func saveCurrentScore(_ score: Int)
    func saveHighestScore(_ score: Int)
    func fetchCurrentScore() -> Int
    func fetchHighestScore() -> Int
}
