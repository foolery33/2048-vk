//
//  GameViewModel.swift
//  2048-vk
//
//  Created by admin on 07.05.2023.
//

import Foundation

protocol Game2048Protocol {
    func generateFirstCells() -> [GameCellViewProtocol]
    func generateSingleCell(cells: [GameCellViewProtocol], dimension: Int) -> GameCellViewProtocol?
    func configureNewCell(number: CellNumber, position: (Int, Int)) -> GameCellViewProtocol
    func getGameState(cells: [GameCellViewProtocol], dimension: Int, winThreshold: Int) -> GameState
    func saveCurrentSession(cells: [GameCellViewProtocol])
    func getLastSession() -> [GameCellViewProtocol]?
    func saveCurrentScore(_ score: Int)
    func saveHighestScore(_ score: Int)
    func fetchCurrentScore() -> Int
    func fetchHighestScore() -> Int
    var appearanceProviderRepository: AppearanceProviderRepository { get }
}

final class GameViewModel {
    
    weak var coordinator: GameCoordinator?
    private(set) var gameSessionRepository: GameSessionRepository
    private(set) var appearanceProviderRepository: AppearanceProviderRepository
    private(set) var scoreManagerRepository: ScoreManagerRepository
    private(set) var swipeGestureUseCase: SwipeGestureUseCase
    private let generateFirstCellsUseCase: GenerateFirstCellsUseCase
    private let generateSingleCellUseCase: GenerateSingleCellUseCase
    private let configureNewCellUseCase: ConfigureNewCellUseCase
    private(set) var getMergedCellsIndiciesUseCase: GetMergedCellsIndiciesUseCase
    private(set) var getMergeResultCellsUseCase: GetMergeResultCellsUseCase
    private(set) var getGameStateUseCase: GetGameStateUseCase
    
    init(appearanceProvider: AppearanceProviderRepository,
         scoreManagerRepository: ScoreManagerRepository,
         swipeGestureUseCase: SwipeGestureUseCase,
         generateFirstCellsUseCase: GenerateFirstCellsUseCase,
         generateSingleCellUseCase: GenerateSingleCellUseCase,
         configureNewCellUseCase: ConfigureNewCellUseCase,
         getMergedCellsIndiciesUseCase: GetMergedCellsIndiciesUseCase,
         getMergeResultCellsUseCase: GetMergeResultCellsUseCase,
         getGameStateUseCase: GetGameStateUseCase,
         gameSessionRepository: GameSessionRepository) {
        self.appearanceProviderRepository = appearanceProvider
        self.scoreManagerRepository = scoreManagerRepository
        self.swipeGestureUseCase = swipeGestureUseCase
        self.generateFirstCellsUseCase = generateFirstCellsUseCase
        self.generateSingleCellUseCase = generateSingleCellUseCase
        self.configureNewCellUseCase = configureNewCellUseCase
        self.getMergedCellsIndiciesUseCase = getMergedCellsIndiciesUseCase
        self.getMergeResultCellsUseCase = getMergeResultCellsUseCase
        self.getGameStateUseCase = getGameStateUseCase
        self.gameSessionRepository = gameSessionRepository
    }
    
}

extension GameViewModel: Game2048Protocol {
    func generateFirstCells() -> [GameCellViewProtocol] {
        return self.generateFirstCellsUseCase.generate()
    }
    func generateSingleCell(cells: [GameCellViewProtocol], dimension: Int) -> GameCellViewProtocol? {
        return self.generateSingleCellUseCase.generate(cells: cells, dimension: dimension)
    }
    func configureNewCell(number: CellNumber, position: (Int, Int)) -> GameCellViewProtocol {
        return self.configureNewCellUseCase.configure(number: number, position: position)
    }
    func saveCurrentScore(_ score: Int) {
        scoreManagerRepository.saveCurrentScore(score)
    }
    func saveHighestScore(_ score: Int) {
        scoreManagerRepository.saveHighestScore(score)
    }
    func fetchCurrentScore() -> Int {
        scoreManagerRepository.fetchCurrentScore()
    }
    func fetchHighestScore() -> Int {
        scoreManagerRepository.fetchHighestScore()
    }
    func saveCurrentSession(cells: [GameCellViewProtocol]) {
        gameSessionRepository.saveSession(cells: cells)
    }
    func getLastSession() -> [GameCellViewProtocol]? {
        gameSessionRepository.loadSession()
    }
    func getGameState(cells: [GameCellViewProtocol], dimension: Int, winThreshold: Int) -> GameState {
        getGameStateUseCase.getState(cells: cells, dimension: dimension, winThreshold: winThreshold)
    }
}
