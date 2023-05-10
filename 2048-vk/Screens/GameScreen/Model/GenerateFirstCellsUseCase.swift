//
//  GenerateFirstCellsUseCase.swift
//  2048-vk
//
//  Created by admin on 09.05.2023.
//

import Foundation

final class GenerateFirstCellsUseCase {
    
    private let appearanceProviderRepository: AppearanceProviderRepository
    
    init(appearanceProviderRepository: AppearanceProviderRepository) {
        self.appearanceProviderRepository = appearanceProviderRepository
    }
    
    func generate() -> [GameCellViewProtocol] {
        
        var newCells: [GameCellViewProtocol] = []
        
        let firstRandomCell = (Int.random(in: 0...2), Int.random(in: 0...2))
        let firstRandomChange = Int.random(in: 1...100)
        
        var secondRandomCell = firstRandomCell
        let secondRandomChance = Int.random(in: 1...100)
        
        while true {
            secondRandomCell = (Int.random(in: 0...2), Int.random(in: 0...2))
            if secondRandomCell != firstRandomCell {
                break
            }
        }
        let firstCell = GameCellView(number: firstRandomChange <= 90 ? ._2 : ._4, position: firstRandomCell)
        firstCell.appearanceProvider = self.appearanceProviderRepository
        firstCell.configureAppearance()
        newCells.append(firstCell)
        
        let secondCell = GameCellView(number: secondRandomChance <= 90 ? ._2 : ._4, position: secondRandomCell)
        secondCell.appearanceProvider = self.appearanceProviderRepository
        secondCell.configureAppearance()
        newCells.append(secondCell)
        
        return newCells
    }
    
}
