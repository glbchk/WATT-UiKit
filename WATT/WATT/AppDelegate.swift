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
        
        self.window = UIWindow(frame: UIScreen.main.bounds)

        window?.rootViewController = AppViewController(viewModel: AppViewModel(appDelegate: self))
        window?.makeKeyAndVisible()

        return true
    }

}

