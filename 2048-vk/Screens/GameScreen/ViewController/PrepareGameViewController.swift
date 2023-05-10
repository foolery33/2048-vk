//
//  ViewController.swift
//  2048-vk
//
//  Created by admin on 06.05.2023.
//

import UIKit

protocol SwipeSetupDelegate: AnyObject {
    func setupSwipes()
}

final class GameViewController: UIViewController {
    
    let viewModel: GameViewModel
    var dimension: Int
    var winThreshold: Int
    
    let sidePadding: CGFloat = 16.0
    var fieldWidth: CGFloat
    var fieldHeight: CGFloat
    
    init(viewModel: GameViewModel, dimension: Int, winThreshold: Int) {
        self.viewModel = viewModel
        self.dimension = dimension
        self.winThreshold = winThreshold
        fieldWidth = UIScreen.main.bounds.width - 2 * sidePadding
        fieldHeight = fieldWidth
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .screenBackground
        setupSubviews()
        setupSwipes()
    }
    
    private func setupSubviews() {
        setupFourXFourField()
    }
    
    // MARK: - FourXFourField setup
    private lazy var fourXFourField: GameStackView = {
        let myField = GameStackView(game2048Protocol: viewModel, dimension: dimension, winThreshold: winThreshold, fieldWidth: fieldWidth, fieldHeight: fieldWidth)
        myField.swipeSetupDelegate = self
        return myField
    }()
    private func setupFourXFourField() {
        view.addSubview(fourXFourField)
        fourXFourField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            fourXFourField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fourXFourField.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func moveCellsWithAnimation() {
        view.isUserInteractionEnabled = false
        var mergedIndicies: [Int] = []
        UIView.animate(withDuration: 0.15, animations: { [self] in
//            fourXFourField.cells = fourXFourField.cells.sorted { $0.position.1 < $1.position.1 }
            
            // Заполняем массив mergedIndicies. В нём хранятся индексы тех клеток, которые были смёрджены => которые надо удалить с экрана
            mergedIndicies = viewModel.getMergedCellsIndiciesUseCase.getMergedIndicies(cells: fourXFourField.cells)
            
            // Добавляем клетки, полученные в результате мёрджа каких-то двух клеток
            let mergeResultCells = viewModel.getMergeResultCellsUseCase.getCells(from: fourXFourField.cells)
            for mergeResultCell in mergeResultCells {
                fourXFourField.addMergeResultCell(mergeResultCell)
            }
            // Обновляем констрейнты у всех клеток
            for i in 0..<fourXFourField.cells.count {
                fourXFourField.setCellConstraints(cell: fourXFourField.cells[i])
            }
            fourXFourField.layoutIfNeeded()
        }) { [self] _ in
            // Удаляем все клетки, которые были смёрджены
            for index in mergedIndicies.sorted().reversed() {
                fourXFourField.cells[index].removeFromSuperview()
                fourXFourField.cells.remove(at: index)
            }
            setupNewCell()
            let gameState = viewModel.getGameStateUseCase.getState(cells: fourXFourField.cells, dimension: dimension, winThreshold: winThreshold)
            switch gameState {
            case .playing:
                break
            case .gameOver:
                setupGameOver()
            case .gameWon:
                setupWinCondition()
            }
            viewModel.saveCurrentSession(cells: fourXFourField.cells)
            view.isUserInteractionEnabled = true
        }
    }
    
    private func setupWinCondition() {
        fourXFourField.setupWinCondition()
        removeSwipeGestures()
    }
    
    private func setupNewCell() {
        fourXFourField.spawnNewCell()
    }
    
    private func setupGameOver() {
        fourXFourField.setupGameOverCondition()
        removeSwipeGestures()
    }
    
    private func removeSwipeGestures() {
        view.gestureRecognizers?.forEach { gestureRecognizer in
            if let swipeGestureRecognizer = gestureRecognizer as? UISwipeGestureRecognizer {
                view.removeGestureRecognizer(swipeGestureRecognizer)
            }
        }
    }
    
    private func saveLastStepCells() {
        // Сохраняем текущие позиции и номиналы клеток, чтобы можно было сделать ход назад
        fourXFourField.lastStepCells = fourXFourField.cells.map {
            let currentCellPosition: (Int, Int) = $0.position
            let currentCellNumber: CellNumber = $0.number
            return GameCellView(number: currentCellNumber, position: currentCellPosition)
        }
    }
    
}

extension GameViewController: SwipeSetupDelegate {
    func setupSwipes() {
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(onSwipe(_:)))
        upSwipe.numberOfTouchesRequired = 1
        upSwipe.direction = .up
        view.addGestureRecognizer(upSwipe)
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(onSwipe(_:)))
        downSwipe.numberOfTouchesRequired = 1
        downSwipe.direction = .down
        view.addGestureRecognizer(downSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(onSwipe(_:)))
        leftSwipe.numberOfTouchesRequired = 1
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(onSwipe(_:)))
        rightSwipe.numberOfTouchesRequired = 1
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
    }
    
    @objc private func onSwipe(_ sender: UISwipeGestureRecognizer) {
        let currentCells = fourXFourField.cells.map {
            let currentCellPosition: (Int, Int) = $0.position
            let currentCellNumber: CellNumber = $0.number
            return GameCellView(number: currentCellNumber, position: currentCellPosition)
        }
        switch sender.direction {
        case .up:
            if viewModel.swipeGestureUseCase.onUpSwipe(cells: &fourXFourField.cells) {
                moveCellsWithAnimation()
                fourXFourField.lastStepCells = currentCells
            }
        case .down:
            if viewModel.swipeGestureUseCase.onDownSwipe(cells: &fourXFourField.cells, dimension: dimension) {
                moveCellsWithAnimation()
                fourXFourField.lastStepCells = currentCells
            }
        case .left:
            if viewModel.swipeGestureUseCase.onLeftSwipe(cells: &fourXFourField.cells) {
                moveCellsWithAnimation()
                fourXFourField.lastStepCells = currentCells
            }
        case.right:
            if viewModel.swipeGestureUseCase.onRightSwipe(cells: &fourXFourField.cells, dimension: dimension) {
                moveCellsWithAnimation()
                fourXFourField.lastStepCells = currentCells
            }
        default:
            break
        }
    }
}
