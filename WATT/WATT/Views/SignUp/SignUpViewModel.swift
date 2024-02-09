//
//  SignUpViewModel.swift
//  WATT
//
//  Created by Glib Galchenko on 11/01/24.
//

import UIKit
import Foundation
import Combine
import Swinject

enum TextFieldState {
    case loading
    case success
    case failed
    case none
}

class SignUpViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var fullName = ""
    @Published var password = ""
    @Published var phoneNumber = ""
    @Published var profilePhoto: UIImage? = nil
    @Published var isLoading = false
    @Published var state: TextFieldState = .none
    private var cancellables = Set<AnyCancellable>()
    
    @Published var user: AppUser?
    
    @Published var showPassword = true
    @Published var showRetyped = true
    
    var passwordPublisher: AnyPublisher<Bool, Never> {
        $showPassword
            .eraseToAnyPublisher()
    }
    
    var retypedPasswordPublisher: AnyPublisher<Bool, Never> {
        $showRetyped
            .eraseToAnyPublisher()
    }
    
    private(set) lazy var isInputValid = Publishers.CombineLatest($email, $password)
        .map { $0.count > 2 && $1.count > 2 }
        .eraseToAnyPublisher()
    
    private let authenticationRepo: AuthenticationRepository
    private let loginRepo: LoginRepository
    private var userRepo: UserRepository
    
    init(dependencies: Resolver) {
        authenticationRepo = dependencies.resolve(AuthenticationRepository.self)!
        loginRepo = dependencies.resolve(LoginRepository.self)!
        userRepo = dependencies.resolve(UserRepository.self)!
    }
    
    func validateCredentials(login: String, password: String, completion: @escaping (Result<(), Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(.success(()))
        }
    }
    
    func createUser(completion: @escaping ((Bool, String) -> Void)) {
        Task(priority: .medium) { [loginRepo] in
            do {
                let user = try await loginRepo.createUser(email: email, password: password)
                DispatchQueue.main.async { [weak self] in
                    self?.user = user
                }
                isLoading = true
                completion(true, "")
            } catch {
                print("Error:", error)
                isLoading = false
                completion(false, error.localizedDescription)
            }
            
        }
    }
    
    func successfulRegistration() {
        guard let user = self.user else { return }
        let dbUser = DBUser(uid: user.uid, email: email)
        Task(priority: .medium) {
            try await userRepo.createUserInDB(user: dbUser)
            authenticationRepo.success()
        }
    }
    
    var isValidUsernamePublisher: AnyPublisher<Bool, Never> {
        $email
            .map { $0.isValidEmail }
            .eraseToAnyPublisher()
    }

    var isValidPasswordPublisher: AnyPublisher<Bool, Never> {
        $password
            .map { !$0.isEmpty }
            .eraseToAnyPublisher()
    }

    var isSubmitEnabled: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isValidUsernamePublisher, isValidPasswordPublisher)
            .map { $0 && $1 }
            .eraseToAnyPublisher()
    }

    func submitLogin() {
        state = .loading
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            if self.isCorrectLogin() {
                self.state = .success
            } else {
                self.state = .failed
            }
        }
    }

    func isCorrectLogin() -> Bool {
        if email.contains("@") && password.count >= 6 {
            return true
        }
        return false
    }
    
}


extension String {
    var isValidEmail: Bool {
        return NSPredicate(
            format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        )
        .evaluate(with: self)
    }
}
