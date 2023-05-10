//
//  GameFieldView.swift
//  2048-vk
//
//  Created by admin on 10.05.2023.
//

import UIKit

final class GameFieldView: UIView {
    
    private let betweenCellsPadding: CGFloat
    private let cellWidth: CGFloat
    private let cellHeight: CGFloat
    private let dimension: Int
    
    init(betweenCellsPadding: CGFloat, cellWidth: CGFloat, cellHeight: CGFloat, dimension: Int) {
        self.betweenCellsPadding = betweenCellsPadding
        self.cellWidth = cellWidth
        self.cellHeight = cellHeight
        self.dimension = dimension
        super.init(frame: .zero)
        setupGameField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupGameField() {
        self.backgroundColor = .gameFieldBackground
        self.layer.cornerRadius = 6
        self.layer.masksToBounds = true
        setupEmptyCells()
    }
    
    // MARK: - EmptyCells setup
    private func createEmptyCellView() -> UIView {
        let myView = UIView()
        myView.layer.cornerRadius = 6
        myView.layer.masksToBounds = true
        myView.backgroundColor = .emptyCellBackground
        return myView
    }
    private func setupEmptyCells() {
        for x in 0..<self.dimension {
            for y in 0..<self.dimension {
                let myEmptyCellView = createEmptyCellView()
                self.addSubview(myEmptyCellView)
                myEmptyCellView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    myEmptyCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.betweenCellsPadding + CGFloat(x) * (self.betweenCellsPadding + self.cellWidth)),
                    myEmptyCellView.topAnchor.constraint(equalTo: self.topAnchor, constant: self.betweenCellsPadding + CGFloat(y) * (self.betweenCellsPadding + self.cellHeight)),
                    myEmptyCellView.widthAnchor.constraint(equalToConstant: self.cellWidth),
                    myEmptyCellView.heightAnchor.constraint(equalToConstant: self.cellHeight)
                ])

            }
        }
    }
    
}
