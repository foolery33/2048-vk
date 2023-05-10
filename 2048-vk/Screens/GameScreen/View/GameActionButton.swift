//
//  GameActionButton.swift
//  2048-vk
//
//  Created by admin on 08.05.2023.
//

import UIKit

class GameActionButton: UIButton {

    var image: UIImage
    
    init(image: UIImage) {
        self.image = image
        super.init(frame: .zero)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        self.layer.cornerRadius = 6
        self.tintColor = .white
        self.layer.masksToBounds = true
        self.backgroundColor = .gameFieldBackground
        self.setImage(image, for: .normal)
    }
    
}
