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
    
    @Published var email = ""
    @Published var password = ""
    
    @Published var showPassword = false
    
    var sfPublisher: AnyPublisher<Bool, Never> {
        $showPassword
            .eraseToAnyPublisher()
    }
    
    private let authRepo: AuthenticationRepository
    private let loginRepo: LoginRepository
    private let userRepo: UserRepository
    
    init(dependencies: Resolver) {
        authRepo = dependencies.resolve(AuthenticationRepository.self)!
        loginRepo = dependencies.resolve(LoginRepository.self)!
        userRepo = dependencies.resolve(UserRepository.self)!
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
    
}
