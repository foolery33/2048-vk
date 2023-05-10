//
//  CoordinatorFactory.swift
//  2048-vk
//
//  Created by admin on 06.05.2023.
//

import UIKit
import CoreData

final class CoordinatorFactory {
    func createAppCoordinator(navigationController: UINavigationController) -> AppCoordinator {
        return AppCoordinator(navigationController: navigationController)
    }
    func createGameCoordinator(navigationController: UINavigationController) -> GameCoordinator {
        return GameCoordinator(
            navigationController: navigationController,
            gameScreenViewModel: GameViewModel(
                appearanceProvider: AppearanceProviderImplementation(),
                scoreManagerRepository: ScoreManagerImplementation(),
                swipeGestureUseCase: SwipeGestureUseCase(
                    getCellNumberFromNumberUseCase: GetCellNumberFromNumberUseCase()
                ),
                generateFirstCellsUseCase: GenerateFirstCellsUseCase(
                    appearanceProviderRepository: AppearanceProviderImplementation()
                ),
                generateSingleCellUseCase: GenerateSingleCellUseCase(
                    getAvailableCoordinatesUseCase: GetAvailableCoordinatesUseCase(),
                    configureNewCellUseCase: ConfigureNewCellUseCase(
                        appearanceProviderRepository: AppearanceProviderImplementation()
                    )
                ),
                configureNewCellUseCase: ConfigureNewCellUseCase(
                    appearanceProviderRepository: AppearanceProviderImplementation()
                ),
                getMergedCellsIndiciesUseCase: GetMergedCellsIndiciesUseCase(),
                getMergeResultCellsUseCase: GetMergeResultCellsUseCase(),
                getGameStateUseCase: GetGameStateUseCase(
                    isGameWonUseCase: IsGameWonUseCase(),
                    canMakeMoveUseCase: CanMakeMoveUseCase()
                ),
                gameSessionRepository: GameSessionRepositoryImplementation(
                    getCellNumberFromNumberUseCase: GetCellNumberFromNumberUseCase(),
                    managedObjectContext: setupContext()
                )
            )
        )
    }
    func setupContext() -> NSManagedObjectContext {
        // Создание NSPersistentContainer
        let container = NSPersistentContainer(name: "GameCellModel")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                print("Failed to load persistent stores: \(error)")
                return
            }
        }

        // Создание NSManagedObjectContext
        let context = container.viewContext
        return context
    }
    
}
