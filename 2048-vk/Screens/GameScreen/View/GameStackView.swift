//
//  GameFieldStackView.swift
//  2048-vk
//
//  Created by admin on 09.05.2023.
//

import UIKit

final class GameStackView: UIStackView {

    private let game2048Protocol: Game2048Protocol
    var dimension: Int
    var winThreshold: Int
    
    private var betweenCellsPadding: CGFloat
    private var cellWidth: CGFloat
    private var cellHeight: CGFloat
    var fieldWidth: CGFloat
    var fieldHeight: CGFloat
    
    var cells: [GameCellViewProtocol] = []
    var lastStepCells: [GameCellViewProtocol] = []
    
    weak var swipeSetupDelegate: SwipeSetupDelegate?
    
    private let appName: String = "2048"
    
    init(game2048Protocol: Game2048Protocol, dimension: Int, winThreshold: Int, fieldWidth: CGFloat, fieldHeight: CGFloat) {
        self.game2048Protocol = game2048Protocol
        self.dimension = dimension
        self.winThreshold = winThreshold
        self.fieldWidth = fieldWidth
        self.fieldHeight = fieldHeight
        betweenCellsPadding = fieldWidth / CGFloat((dimension * 8 + dimension + 1))
        cellWidth = betweenCellsPadding * 8
        cellHeight = cellWidth
        super.init(frame: .zero)
        setupSubviews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        axis = .vertical
        spacing = 20
        
        setupGameInfoStack()
        setupButtonsStackView()
        setupGameField()
        setupStartCells()
    }
    
    // GameInfoStack setup
    private lazy var gameInfoStack: UIStackView = {
        let myStackView = UIStackView()
        myStackView.axis = .horizontal
        myStackView.spacing = 8
        return myStackView
    }()
    private func setupGameInfoStack() {
        addArrangedSubview(gameInfoStack)
        setupGameNameLabel()
        setupGameInfoSpacerView()
        setupScoreStackView()
        setupHighestScoreStackView()
    }
    
    // MARK: - GameNameLabel setup
    private lazy var gameNameLabel: UILabel = {
        let myGameNameLabel = UILabel()
        myGameNameLabel.textColor = .font2
        myGameNameLabel.text = "2048"
        myGameNameLabel.font = .systemFont(ofSize: 40, weight: .regular)
        return myGameNameLabel
    }()
    private func setupGameNameLabel() {
        gameInfoStack.addArrangedSubview(gameNameLabel)
    }
    
    // MARK: - GameInfoSpacerView setup
    private lazy var gameInfoSpacerView: UIView = {
        return UIView()
    }()
    private func setupGameInfoSpacerView() {
        gameInfoStack.addArrangedSubview(gameInfoSpacerView)
    }
    
    // MARK: - ScoreStackView setup
    private lazy var scoreStackView: ScoreStackView = {
        let myScoreStackView = ScoreStackView(scoreTitle: NSLocalizedString("score", comment: ""), scoreAmount: game2048Protocol.fetchCurrentScore())
        return myScoreStackView
    }()
    private func setupScoreStackView() {
        gameInfoStack.addArrangedSubview(scoreStackView)
    }
    
    // MARK: - HighestScoreStackView setup
    private lazy var highestScoreStackView: ScoreStackView = {
        let myScoreStackView = ScoreStackView(scoreTitle: NSLocalizedString("record", comment: ""), scoreAmount: game2048Protocol.fetchHighestScore())
        return myScoreStackView
    }()
    private func setupHighestScoreStackView() {
        gameInfoStack.addArrangedSubview(highestScoreStackView)
    }
    
    // MARK: ButtonsStackView setup
    private lazy var buttonsStackView: UIStackView = {
        let myStackView = UIStackView()
        myStackView.spacing = 20
        myStackView.axis = .horizontal
        return myStackView
    }()
    private func setupButtonsStackView() {
        addArrangedSubview(buttonsStackView)
        setupHomeButton()
        setupSpacerView()
        setupStepBackButton()
        setupRestartButton()
    }
    
    // MARK: - HomeButton setup
    private lazy var homeButton: GameActionButton = {
        let myButton = GameActionButton(image: UIImage(systemName: "house.fill")!)
        myButton.addTarget(self, action: #selector(onHomeButtonTapped), for: .touchUpInside)
        return myButton
    }()
    @objc private func onHomeButtonTapped() {
        print("Home")
    }
    private func setupHomeButton() {
        buttonsStackView.addArrangedSubview(homeButton)
        homeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            homeButton.widthAnchor.constraint(equalToConstant: 42),
            homeButton.heightAnchor.constraint(equalToConstant: 42)
        ])

    }
    
    // MARK: - RestartButton setup
    private lazy var restartButton: GameActionButton = {
        let myButton = GameActionButton(image: UIImage(systemName: "arrow.triangle.2.circlepath", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .bold))!)
        myButton.addTarget(self, action: #selector(onRestartButtonTapped), for: .touchUpInside)
        return myButton
    }()
    @objc private func onRestartButtonTapped() {
        restartGame()
        scoreStackView.updateScore(to: 0)
        game2048Protocol.saveCurrentSession(cells: cells)
        game2048Protocol.saveCurrentScore(0)
        restorePlayability()
    }
    private func restorePlayability() {
        winGameView.removeFromSuperview()
        gameOverView.removeFromSuperview()
        restartButton.backgroundColor = .gameFieldBackground
        swipeSetupDelegate?.setupSwipes()
    }
    private func setupRestartButton() {
        buttonsStackView.addArrangedSubview(restartButton)
        restartButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            restartButton.widthAnchor.constraint(equalToConstant: 42),
            restartButton.heightAnchor.constraint(equalToConstant: 42)
        ])

    }
    
    // MARK: - SpacerView setup
    private lazy var spacerView: UIView = {
        return UIView()
    }()
    private func setupSpacerView() {
        buttonsStackView.addArrangedSubview(spacerView)
    }
    
    // MARK: - StepBackButton setup
    private lazy var stepBackButton: GameActionButton = {
        let myButton = GameActionButton(image: UIImage(systemName: "arrowshape.turn.up.left.fill")!)
        myButton.addTarget(self, action: #selector(onStepBackButtonTapped), for: .touchUpInside)
        return myButton
    }()
    @objc private func onStepBackButtonTapped() {
        // Ничего не делаем, если предыдущего хода не было (или если ранее уже нажали кнопку назад)
        if lastStepCells.isEmpty {
            return
        }
        restorePlayability()
        // Удаляем все клетки
        for cell in gameField.subviews {
            if cell is GameCellViewProtocol {
                cell.removeFromSuperview()
            }
        }
        
        cells = lastStepCells
        lastStepCells = []
        // Устанавливаем клетки, которые были на предыдущем шаге
        for cell in cells {
            cell.appearanceProvider = game2048Protocol.appearanceProviderRepository
            cell.configureAppearance()
            setupCell(cell)
        }
        
        // Сохраняем сессию в базу данных
        game2048Protocol.saveCurrentSession(cells: cells)
    }
    private func setupStepBackButton() {
        buttonsStackView.addArrangedSubview(stepBackButton)
        stepBackButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stepBackButton.widthAnchor.constraint(equalToConstant: 42),
            stepBackButton.heightAnchor.constraint(equalToConstant: 42)
        ])
    }
    
    private lazy var gameField: GameFieldView = {
        let myGameField = GameFieldView(betweenCellsPadding: betweenCellsPadding, cellWidth: cellWidth, cellHeight: cellHeight, dimension: dimension)
        return myGameField
    }()
    private func setupGameField() {
        addArrangedSubview(gameField)
        gameField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gameField.widthAnchor.constraint(equalToConstant: fieldWidth),
            gameField.heightAnchor.constraint(equalToConstant: fieldHeight)
        ])

    }
    
    // MARK: - WinView setup
    private lazy var winGameView: UIView = {
        let myView = UIView()
        myView.backgroundColor = .background2048.withAlphaComponent(0.3)
        return myView
    }()
    private func setupWinGameView() {
        gameField.addSubview(winGameView)
        setupWinGameLabel()
        winGameView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            winGameView.topAnchor.constraint(equalTo: gameField.topAnchor),
            winGameView.leadingAnchor.constraint(equalTo: gameField.leadingAnchor),
            winGameView.trailingAnchor.constraint(equalTo: gameField.trailingAnchor),
            winGameView.bottomAnchor.constraint(equalTo: gameField.bottomAnchor)
        ])

    }
    
    // MARK: - WinGameLabel setup
    private lazy var winGameLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.textColor = .white
        myLabel.text = NSLocalizedString("you_won", comment: "")
        myLabel.font = .systemFont(ofSize: 36, weight: .medium)
        return myLabel
    }()
    private func setupWinGameLabel() {
        winGameView.addSubview(winGameLabel)
        winGameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            winGameLabel.centerXAnchor.constraint(equalTo: winGameView.centerXAnchor),
            winGameLabel.centerYAnchor.constraint(equalTo: winGameView.centerYAnchor)
        ])

    }
    
    func setupWinCondition() {
        setupWinGameView()
        winGameView.alpha = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            UIView.animate(withDuration: 1) { [self] in
                winGameView.alpha = 1
                restartButton.backgroundColor = .background2048
                layoutIfNeeded()
            }
        }
    }
    
    // MARK: - GameOverView setup
    private lazy var gameOverView: UIView = {
        let myView = UIView()
        myView.backgroundColor = .gameFieldBackground.withAlphaComponent(0.3)
        return myView
    }()
    private func setupGameOverView() {
        gameField.addSubview(gameOverView)
        setupGameOverLabel()
        gameOverView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gameOverView.leadingAnchor.constraint(equalTo: gameField.leadingAnchor),
            gameOverView.trailingAnchor.constraint(equalTo: gameField.trailingAnchor),
            gameOverView.topAnchor.constraint(equalTo: gameField.topAnchor),
            gameOverView.bottomAnchor.constraint(equalTo: gameField.bottomAnchor)
        ])

    }
    
    // MARK: - WinGameLabel setup
    private lazy var gameOverLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.textColor = .font2
        myLabel.text = NSLocalizedString("game_over", comment: "")
        myLabel.font = .systemFont(ofSize: 36, weight: .medium)
        return myLabel
    }()
    private func setupGameOverLabel() {
        gameOverView.addSubview(gameOverLabel)
        gameOverLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gameOverLabel.centerXAnchor.constraint(equalTo: gameOverView.centerXAnchor),
            gameOverLabel.centerYAnchor.constraint(equalTo: gameOverView.centerYAnchor)
        ])

    }
    
    func setupGameOverCondition() {
        setupGameOverView()
        gameOverView.alpha = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            UIView.animate(withDuration: 1) { [self] in
                gameOverView.alpha = 1
                restartButton.backgroundColor = .background2048
                layoutIfNeeded()
            }
        }
    }
    
    func addMergeResultCell(_ cell: GameCellViewProtocol) {
        let mergedCell = cell
        scoreStackView.updateScore(add: mergedCell.number.rawValue)
        game2048Protocol.saveCurrentScore(scoreStackView.scoreAmount)
        game2048Protocol.saveHighestScore(scoreStackView.scoreAmount)
        
        highestScoreStackView.updateScore(to: game2048Protocol.fetchHighestScore())
        mergedCell.appearanceProvider = game2048Protocol.appearanceProviderRepository
        mergedCell.configureAppearance()
        setupCell(mergedCell)
    }
    
    private func setupCell(_ cell: GameCellViewProtocol) {
        cell.transform = CGAffineTransform(scaleX: 0, y: 0)
        gameField.addSubview(cell)
        UIView.animate(withDuration: 0.1, animations: { [self] in
            cell.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            setCellConstraints(cell: cell)
        }) { _ in
            UIView.animate(withDuration: 0.15) {
                cell.transform = .identity
            }
        }
    }
    
    private func createFirstCells() {
        let startCells = game2048Protocol.generateFirstCells()
        for cell in startCells {
            let currentCell = game2048Protocol.configureNewCell(number: cell.number, position: cell.position)
            cells.append(currentCell)
        }
    }
    
    func restartGame() {
        for subview in gameField.subviews {
            if subview is GameCellViewProtocol {
                subview.removeFromSuperview()
            }
        }
        cells = []
        setupFirstCells()
    }
    
    private func setupStartCells() {
        if let previousSessionCells = game2048Protocol.getLastSession() {
            cells = previousSessionCells
            for cell in cells {
                cell.appearanceProvider = game2048Protocol.appearanceProviderRepository
                cell.configureAppearance()
                setupCell(cell)
            }
            switch game2048Protocol.getGameState(cells: cells, dimension: dimension, winThreshold: winThreshold) {
            case.gameOver:
                setupGameOverCondition()
            case .gameWon:
                setupWinCondition()
            case .playing:
                break
            }
        }
        else {
            setupFirstCells()
        }
    }
    
    private func setupFirstCells() {
        createFirstCells()
        for cell in cells {
            setupCell(cell)
        }
    }
    
    func spawnNewCell() {
        if let newCell = game2048Protocol.generateSingleCell(cells: cells, dimension: dimension) {
            cells.append(newCell)
            setupCell(newCell)
        }
    }
    
    func setCellConstraints(cell: GameCellViewProtocol) {
        cell.removeFromSuperview()
        gameField.addSubview(cell)
        cell.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cell.leadingAnchor.constraint(equalTo: gameField.leadingAnchor, constant: betweenCellsPadding + CGFloat(cell.position.0) * (betweenCellsPadding + cellWidth)),
            cell.topAnchor.constraint(equalTo: gameField.topAnchor, constant: betweenCellsPadding + CGFloat(cell.position.1) * (betweenCellsPadding + cellWidth)),
            cell.widthAnchor.constraint(equalToConstant: cellWidth),
            cell.heightAnchor.constraint(equalToConstant: cellHeight)
        ])

    }
    
    func deleteCells() {
        for cell in cells {
            cell.removeFromSuperview()
        }
    }
    
}
