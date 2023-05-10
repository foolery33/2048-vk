//
//  ConfigureNewCellUseCase.swift
//  2048-vk
//
//  Created by admin on 09.05.2023.
//

import Foundation

final class ConfigureNewCellUseCase {
    
    private let appearanceProviderRepository: AppearanceProviderRepository
    
    init(appearanceProviderRepository: AppearanceProviderRepository) {
        self.appearanceProviderRepository = appearanceProviderRepository
    }
    
    func configure(number: CellNumber, position: (Int, Int)) -> GameCellViewProtocol {
        let newCell = GameCellView(number: number, position: position)
        newCell.appearanceProvider = self.appearanceProviderRepository
        newCell.configureAppearance()
        return newCell
    }
    
}
