//
//  GetGameStateUseCase.swift
//  2048-vk
//
//  Created by admin on 10.05.2023.
//

import Foundation

final class GetGameStateUseCase {
    
    private let isGameWonUseCase: IsGameWonUseCase
    private let canMakeMoveUseCase: CanMakeMoveUseCase
    
    init(isGameWonUseCase: IsGameWonUseCase, canMakeMoveUseCase: CanMakeMoveUseCase) {
        self.isGameWonUseCase = isGameWonUseCase
        self.canMakeMoveUseCase = canMakeMoveUseCase
    }
    
    func getState(cells: [GameCellViewProtocol], dimension: Int, winThreshold: Int) -> GameState {
        if isGameWonUseCase.isGameWon(cells: cells, winThreshold: winThreshold) {
            return .gameWon
        }
        if canMakeMoveUseCase.canMakeMove(cells: cells, dimension: dimension) {
            return .playing
        }
        else {
            return .gameOver
        }
        
        
    }
    
}
