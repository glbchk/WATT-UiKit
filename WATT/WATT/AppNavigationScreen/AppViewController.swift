//
//  AppViewController.swift
//  WATT
//
//  Created by Glib Galchenko on 29/01/24.
//

import UIKit
import Combine

class AppViewController: UINavigationController {
    
    //    private lazy var navigationView = AppView()
    private var viewModel: AppViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private var window: UIWindow?
    
    init(viewModel: AppViewModel, window: UIWindow?) {
        self.viewModel = viewModel
        self.window = window
        super.init(nibName: nil, bundle: nil)
        loginState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    private func loginState() {
        
        viewModel.isLoggedPublisher
            .sink { [self] isLogged in
                if isLogged == true {
                    if let mainViewModel = viewModel.mainViewModel {
                        self.window?.rootViewController = UINavigationController(rootViewController: MainViewController(viewModel: mainViewModel))
                    }
                } else {
                    if let signUpViewModel = viewModel.signUpViewModel {
                        self.window?.rootViewController = UINavigationController(rootViewController: SignUpController(viewModel: signUpViewModel))
                    }
                }
            }
            .store(in: &cancellables)
    }
    
}
