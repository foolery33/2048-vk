//
//  CanMakeMoveUseCase.swift
//  2048-vk
//
//  Created by admin on 10.05.2023.
//

import Foundation

final class CanMakeMoveUseCase {
    
    func canMakeMove(cells: [GameCellViewProtocol], dimension: Int) -> Bool {
        for cell in cells {
            let (row, col) = cell.position
            
            // Проверяем, есть ли пустая соседняя клетка
            if row > 0 && cells.first(where: { $0.position == (row - 1, col) }) == nil {
                return true
            }
            if row < dimension - 1 && cells.first(where: { $0.position == (row + 1, col) }) == nil {
                return true
            }
            if col > 0 && cells.first(where: { $0.position == (row, col - 1) }) == nil {
                return true
            }
            if col < dimension - 1 && cells.first(where: { $0.position == (row, col + 1) }) == nil {
                return true
            }
            
            // Проверяем, есть ли соседняя клетка с таким же number
            if row > 0 && cells.contains(where: { $0.position == (row - 1, col) && $0.number == cell.number }) {
                return true
            }
            if row < dimension - 1 && cells.contains(where: { $0.position == (row + 1, col) && $0.number == cell.number }) {
                return true
            }
            if col > 0 && cells.contains(where: { $0.position == (row, col - 1) && $0.number == cell.number }) {
                return true
            }
            if col < dimension - 1 && cells.contains(where: { $0.position == (row, col + 1) && $0.number == cell.number }) {
                return true
            }
        }
        
        return false
    }
    
}
