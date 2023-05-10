//
//  GameCellView.swift
//  2048-vk
//
//  Created by admin on 06.05.2023.
//

import UIKit

protocol GameCellViewProtocol: UIView {
    var id: UUID { get }
    var number: CellNumber { get set }
    var position: (Int, Int) { get set }
    var appearanceProvider: AppearanceProviderRepository? { get set }
    func configureAppearance()
}

class GameCellView: UIView, GameCellViewProtocol {

    var number: CellNumber
    var position: (Int, Int)
    var id: UUID
    weak var appearanceProvider: AppearanceProviderRepository?

    init(number: CellNumber, position: (Int, Int)) {
        self.number = number
        self.position = position
        id = UUID()
        super.init(frame: .zero)
        setupGameCellView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureAppearance() {
        numberLabel.textColor = appearanceProvider?.getCellFontColor(for: number)
        backgroundColor = appearanceProvider?.getCellBackgroundColor(for: number)
    }
    
    // MARK: - GameCellView setup
    private func setupGameCellView() {
        layer.cornerRadius = 6
        layer.masksToBounds = true
        setupNumberLabel()
    }
    
    // MARK: - NumberLabel setup
    private lazy var numberLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.text = String(number.rawValue)
        myLabel.font = .systemFont(ofSize: 28, weight: .medium)
        return myLabel
    }()
    private func setupNumberLabel() {
        addSubview(numberLabel)
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            numberLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            numberLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

    }
    
}
