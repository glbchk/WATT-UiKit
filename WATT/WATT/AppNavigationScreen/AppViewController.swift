//
//  AppViewController.swift
//  WATT
//
//  Created by Glib Galchenko on 29/01/24.
//

import UIKit
import Combine

class AppViewController: UINavigationController {
    private var cancellables = Set<AnyCancellable>()
    
    private var viewModel: AppViewModel
    
    init(viewModel: AppViewModel) {
        self.viewModel = viewModel
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
            .sink { [weak self] isLogged in
                guard let self = self else { return }
                if isLogged == true {
                    if let mainViewModel = viewModel.mainViewModel {
                        setViewControllers([MainViewController(viewModel: mainViewModel)], animated: false)
                    }
                } else {
                    if let signInViewModel = viewModel.signInViewModel {
                        setViewControllers([SignInController(viewModel: signInViewModel)], animated: false)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
}
