//
//  SceneDelegate.swift
//  2048-vk
//
//  Created by admin on 06.05.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(true, animated: false)
        appCoordinator = CoordinatorFactory().createAppCoordinator(navigationController: navigationController)
        window = UIWindow(windowScene: windowScene)

        appCoordinator?.start()
        
        window?.rootViewController = appCoordinator?.navigationController
        window?.makeKeyAndVisible()
    }

}

