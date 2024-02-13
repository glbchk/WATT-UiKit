//
//  SignInViewModel.swift
//  WATT
//
//  Created by Glib Galchenko on 03/02/24.
//

import Foundation
import Combine
import Swinject

class SignInViewModel: ObservableObject {
    
    //Need to do something
    @Published var email = ""
    @Published var password = ""
    @Published var error = ""
    
    @Published var showPassword = false
    
    private let authRepo: AuthenticationRepository
    private let loginRepo: LoginRepository
    private let userRepo: UserRepository
    let signUpViewModel: SignUpViewModel?
    
    init(dependencies: Resolver) {
        authRepo = dependencies.resolve(AuthenticationRepository.self)!
        loginRepo = dependencies.resolve(LoginRepository.self)!
        userRepo = dependencies.resolve(UserRepository.self)!
        signUpViewModel = SignUpViewModel(dependencies: dependencies)
    }
    
    func logIn(completion: @escaping ((String) -> Void)) {
        Task(priority: .medium) { [authRepo, loginRepo] in
            do {
                _ = try await loginRepo.logIn(email: email, password: password)
                authRepo.success()
            } catch {
                print("Error:", error.localizedDescription)
                completion(error.localizedDescription)
            }
            
        }
    }
    
    var sfPublisher: AnyPublisher<Bool, Never> {
        $showPassword
            .eraseToAnyPublisher()
    }
    
    var isValidEmailPublisher: AnyPublisher<Bool, Never> {
        $email
            .map { $0.isValidEmail }
            .eraseToAnyPublisher()
    }
    
    var isValidPasswordPublisher: AnyPublisher<Bool, Never> {
        $password
            .map { !$0.isEmpty && $0.count > 6 }
            .eraseToAnyPublisher()
    }
    
    var isSubmitEnabled: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isValidEmailPublisher, isValidPasswordPublisher)
            .map { $0 && $1 }
            .eraseToAnyPublisher()
    }
    
}
