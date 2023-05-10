//
//  AppCoordinator.swift
//  2048-vk
//
//  Created by admin on 06.05.2023.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        goToGame()
    }
    
    func goToGame() {
        let gameCoordinator = CoordinatorFactory().createGameCoordinator(navigationController: self.navigationController)
        gameCoordinator.parentCoordinator = self
        children.append(gameCoordinator)
        gameCoordinator.start()
    }
    
}
