//
//  GetAvailableCoordinatesUseCase.swift
//  2048-vk
//
//  Created by admin on 09.05.2023.
//

import Foundation

final class GetAvailableCoordinatesUseCase {
    
    func getCoordinates(cells: [GameCellViewProtocol], dimension: Int) -> [(Int, Int)] {
        
        var availableCoordinates = [(Int, Int)]()
        for x in 0..<dimension {
            for y in 0..<dimension {
                var foundUnique = true
                for cell in cells {
                    if cell.position ==  (x, y) {
                        foundUnique = false
                        break
                    }
                }
                if foundUnique {
                    availableCoordinates.append((x, y))
                }
            }
        }
        return availableCoordinates
        
    }
}
