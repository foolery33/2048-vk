//
//  SpawnNewCellUseCase.swift
//  2048-vk
//
//  Created by admin on 09.05.2023.
//

import Foundation

final class GenerateSingleCellUseCase {
    
    private let getAvailableCoordinatesUseCase: GetAvailableCoordinatesUseCase
    private let configureNewCellUseCase: ConfigureNewCellUseCase
    
    init(getAvailableCoordinatesUseCase: GetAvailableCoordinatesUseCase, configureNewCellUseCase: ConfigureNewCellUseCase) {
        self.getAvailableCoordinatesUseCase = getAvailableCoordinatesUseCase
        self.configureNewCellUseCase = configureNewCellUseCase
    }
    
    func generate(cells: [GameCellViewProtocol], dimension: Int) -> GameCellViewProtocol? {
        if cells.count < dimension * dimension {
            let availableCoordinates = getAvailableCoordinatesUseCase.getCoordinates(cells: cells, dimension: dimension)
            
            let randomIndex = Int.random(in: 0..<availableCoordinates.count)
            // По правилам игры с шансом 90% спавнится двойка, а с шансом 10% - четвёрка
            let randomChance = Int.random(in: 1...100)
            
            // Генерируем новую клетку
            let newCell = configureNewCellUseCase.configure(number: randomChance <= 90 ? ._2 : ._4, position: availableCoordinates[randomIndex])
            return newCell
        }
        else {
            return nil
        }
    }
    
}
