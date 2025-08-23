//
//  SceneDelegate.swift
//  AuthorizationAppDemo
//
//  Created by Konstantin on 18.08.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let window = UIWindow(windowScene: windowScene)

        let access = SettingsUserDefaults.shared.fetchPasswordRequestStatus().requestPassword
        if access {
            window.rootViewController = storyboard.instantiateViewController(withIdentifier: "navigationVC")
        } else {
            window.rootViewController = storyboard.instantiateViewController(withIdentifier: "loginViewController")
        }

        self.window = window
        window.makeKeyAndVisible()
    }
}

