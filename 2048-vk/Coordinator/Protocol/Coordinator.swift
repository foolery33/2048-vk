//
//  Coordinator.swift
//  2048-vk
//
//  Created by admin on 06.05.2023.
//

import UIKit

protocol Coordinator {
    
    var parentCoordinator: Coordinator? { get set }
    var children: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
    
}

extension Coordinator {
    mutating func childDidFinish(_ coordinator: Coordinator) {
        for (index, child) in children.enumerated() {
            if child as AnyObject === coordinator as AnyObject {
                children.remove(at: index)
                break
            }
        }
    }
}
