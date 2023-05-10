//
//  IsGameWonUseCase.swift
//  2048-vk
//
//  Created by admin on 10.05.2023.
//

import Foundation

final class IsGameWonUseCase {
    
    func isGameWon(cells: [GameCellViewProtocol], winThreshold: Int) -> Bool {
        for cell in cells {
            if cell.number.rawValue == winThreshold {
                return true
            }
        }
        return false
    }
    
}
