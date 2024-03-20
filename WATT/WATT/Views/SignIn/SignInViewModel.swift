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
    @Published var error = ""
    
    @Published var user: AppUser?
    
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
    
    func signInAnonymously(completion: @escaping ((Result<Bool, Error>) async throws -> Void)) async throws {
        Task(priority: .medium) { [loginRepo] in
            do {
                let user = try await loginRepo.signInAnonymously()
                DispatchQueue.main.async {
                    self.user = user
                }
                try await completion(.success(true))
            } catch {
                print("Error:", error)
                try await completion(.failure(error))
            }
        }
    }
    
    func successfulAnonymousRegistration() async throws {
        guard let user = self.user else { return }
        let dbUser = DBUser(uid: user.uid, isAnonymous: user.isAnonymous)
        try await userRepo.createAnonymousUserInDB(user: dbUser)
        authRepo.success()
    }
    
    func sendPasswordReset(email: String, completion: @escaping ((Bool) -> Void)) {
        Task(priority: .medium) { [loginRepo] in
            do {
                try await loginRepo.sendPasswordReset(email: email, completion: completion)
            } catch {
                print("Error:", error)
            }
        }
    }
    
    var sfPublisher: AnyPublisher<Bool, Never> {
        $showPassword
            .eraseToAnyPublisher()
    }
    
    var isValidEmailPublisher: AnyPublisher<Result<Bool, TFError>, Never> {
        $email
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .map { $0.isEmpty ? .success(false) : ($0.isValidEmail ? .success(true) : .failure(.invalidEmailFormat)) }
            .eraseToAnyPublisher()
    }
    
    var isValidPasswordPublisher: AnyPublisher<Result<Bool, TFError>, Never> {
        $password
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .map { $0.isEmpty ? .success(false) : ($0.count < 6 ? .failure(.invalidPasswordLength) : .success(true)) }
            .eraseToAnyPublisher()
    }
    
    var isSubmitEnabled: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($email, $password)
            .map { $0.isValidEmail && $1.count >= 6 }
            .eraseToAnyPublisher()
    }
    
}
