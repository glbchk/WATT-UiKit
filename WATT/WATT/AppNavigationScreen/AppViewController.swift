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
    
    init(viewModel: AppViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginState()
    }
    
    
    private func loginState() {
        
        viewModel.isLoggedPublisher
            .sink { [self] isLogged in
                if isLogged == true {
                    if let mainViewModel = viewModel.mainViewModel {
                        self.navigationController?.setViewControllers([MainViewController(viewModel: mainViewModel)], animated: true)
                    }
                } else {
                    if let signUpViewModel = viewModel.signUpViewModel {
                        self.navigationController?.setViewControllers([SignUpViewController(viewModel: signUpViewModel)], animated: true)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
}
