//
//  ScoreView.swift
//  2048-vk
//
//  Created by admin on 08.05.2023.
//

import UIKit

class ScoreStackView: UIStackView {

    private let scoreTitle: String
    private(set) var scoreAmount: Int
    
    init(scoreTitle: String, scoreAmount: Int) {
        self.scoreTitle = scoreTitle
        self.scoreAmount = scoreAmount
        super.init(frame: .zero)
        setupStackView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateScore(add score: Int) {
        self.scoreLabel.text = String((Int(scoreLabel.text ?? "0") ?? 0) + score)
        self.scoreAmount += score
    }
    func updateScore(to score: Int) {
        self.scoreLabel.text = String(score)
        self.scoreAmount = score
    }
    
    private func setupStackView() {
        self.distribution = .fill
        self.axis = .vertical
        self.alignment = .center
        self.backgroundColor = .gameFieldBackground
        self.layoutMargins = UIEdgeInsets(top: 4, left: 4, bottom: 0, right: 4)
        self.isLayoutMarginsRelativeArrangement = true
        self.layer.cornerRadius = 6
        self.layer.masksToBounds = true
        
        self.addArrangedSubview(scoreTitleLabel)
        self.addArrangedSubview(scoreLabel)
    }
    
    // MARK: - ScoreTitleLabel setup
    private lazy var scoreTitleLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        myLabel.font = .systemFont(ofSize: 10, weight: .regular)
        myLabel.textColor = .white
        myLabel.text = scoreTitle
        return myLabel
    }()
    
    // MARK: - ScoreLabel setup
    private lazy var scoreLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        myLabel.font = .systemFont(ofSize: 16, weight: .medium)
        myLabel.textColor = .white
        myLabel.text = String(scoreAmount)
        return myLabel
    }()
    
}
