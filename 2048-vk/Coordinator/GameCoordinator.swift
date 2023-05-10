//
//  Coordinator.swift
//  2048-vk
//
//  Created by admin on 07.05.2023.
//

import UIKit

final class GameCoordinator: Coordinator {
    
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    private var gameScreenViewModel: GameViewModel
    var dimension: Int = 4
    var winThreshold: Int = 2048
    
    init(navigationController: UINavigationController, gameScreenViewModel: GameViewModel) {
        self.navigationController = navigationController
        self.gameScreenViewModel = gameScreenViewModel
    }
    
    func start() {
        goToGameScreen()
    }
    
    func goToGameScreen() {
        let gameScreenViewController = GameViewController(viewModel: gameScreenViewModel, dimension: dimension, winThreshold: winThreshold)
        gameScreenViewModel.coordinator = self
        navigationController.pushViewController(gameScreenViewController, animated: true)
    }
    
}
