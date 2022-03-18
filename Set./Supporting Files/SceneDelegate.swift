//
//  SceneDelegate.swift
//  Set.
//
//  Created by Ilia Tsikelashvili on 16.02.22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window : UIWindow?
    var coreDataStack = CoreDataStack(modelName: "Data")

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            self.window = UIWindow(windowScene: windowScene)
            let vc = SetViewController()
            vc.coreDataStack = coreDataStack
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
            self.window?.backgroundColor = .black
        }
    }
}
