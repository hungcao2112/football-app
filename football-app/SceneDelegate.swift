//
//  SceneDelegate.swift
//  football-app
//
//  Created by Hung Cao on 05/01/2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let loginViewController = MatchListViewController()
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UINavigationController(rootViewController: loginViewController)
        self.window = window
        window.makeKeyAndVisible()
    }
}

