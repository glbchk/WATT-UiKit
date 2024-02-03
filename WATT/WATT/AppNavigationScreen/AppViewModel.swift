//
//  AppViewModel.swift
//  WATT
//
//  Created by Glib Galchenko on 29/01/24.
//

import Foundation
import Combine
import Swinject

final class AppViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    @Published var isLoggedIn: Bool
    
    var isLoggedPublisher: AnyPublisher<Bool, Never> {
        $isLoggedIn
            .eraseToAnyPublisher()
    }
    
    private weak var appDelegate: AppDelegate?
    let authorizationDependencies: Resolver
    var signUpViewModel: SignUpViewModel?
    private(set) var mainViewModel: MainViewModel?
    private var appDependencies: Resolver?
    
    private let authenticationRepo: AuthenticationRepository
    
    init(appDelegate: AppDelegate) {
        self.appDelegate = appDelegate
        self.isLoggedIn = false
        authorizationDependencies = appDelegate.dependencyContainer
        authenticationRepo = authorizationDependencies.resolve(AuthenticationRepository.self)!
        signUpViewModel = SignUpViewModel(dependencies: authorizationDependencies)
        
        listenForAuth()
    }
    
    private func listenForAuth() {
        authenticationRepo.isAuthenticated
            .sink { [weak self] isAuthenticated in
                self?.setState(to: isAuthenticated)
            }
            .store(in: &cancellables)
    }
    
    private func setState(to isAuthenticated: Bool) {
        guard let appDelegate = appDelegate else {
            preconditionFailure("Without an AppDelegate the app should not be alive")
        }

        if isAuthenticated {
            let newDependencies = appDelegate.createAppDependencies(with: authorizationDependencies)
            appDependencies = newDependencies
            mainViewModel = MainViewModel(dependencies: newDependencies)
        } else {
//            loginViewModel = SignInViewModel(dependencies: authorizationDependencies)
            signUpViewModel = SignUpViewModel(dependencies: authorizationDependencies)
            
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.isLoggedIn = isAuthenticated
        }
    }
    
}
