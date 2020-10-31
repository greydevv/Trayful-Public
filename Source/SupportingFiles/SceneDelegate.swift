//
//  SceneDelegate.swift
//  Trayful
//
//  Created by Greyson Murray on 11/30/19.
//  Copyright © 2019 Greyson Murray. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = windowScene
        let rootVC = ColorAwareNavigationController(rootViewController: TrayController())
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        saveContext()
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        saveContext()
    }
    
    private func saveContext() {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}

