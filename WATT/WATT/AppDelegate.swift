//
//  AppDelegate.swift
//  WATT
//
//  Created by Glib Galchenko on 25/12/23.
//

import UIKit
import Firebase
import Swinject

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    public var dependencyContainer: Container!

    var window: UIWindow?

    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        dependencyContainer = createAuthDependencies()
//        window?.rootViewController = dependencyContainer.resolve(AppViewController.self)

        let vm = AppViewModel(appDelegate: self)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
//        window?.rootViewController = UINavigationController(rootViewController: SignInController())
        window?.rootViewController = AppViewController(viewModel: vm, window: self.window)
        window?.makeKeyAndVisible()

        return true
    }

}

