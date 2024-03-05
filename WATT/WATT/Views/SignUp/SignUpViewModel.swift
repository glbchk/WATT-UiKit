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

class SignUpViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    @Published var email = ""
    @Published var fullName = ""
    @Published var password = ""
    @Published var retypedPassword = ""
    @Published var phoneNumber = ""
    @Published var profilePhoto: UIImage? = nil
    
    @Published var paymentMethods: [PaymentMethod] = []
    @Published var defaultPaymentMethod: Bool = false
    
    @Published var user: AppUser?
    
    @Published var showPassword = false
    @Published var showRetyped = false
    
    @Published var fakeDataTable = [
        "Audi X8",
        "BMW M9",
        "Tesla Sport Shos..."
    ]
    
    private let authenticationRepo: AuthenticationRepository
    private let loginRepo: LoginRepository
    private var userRepo: UserRepository
    let paymentMethodViewModel: PaymentMethodViewModel?
    
    init(dependencies: Resolver) {
        authenticationRepo = dependencies.resolve(AuthenticationRepository.self)!
        loginRepo = dependencies.resolve(LoginRepository.self)!
        userRepo = dependencies.resolve(UserRepository.self)!
        paymentMethodViewModel = PaymentMethodViewModel(dependencies: dependencies)
    }
    
    func createUser(completion: @escaping ((Bool, String) -> Void)) {
        Task(priority: .medium) { [loginRepo] in
            do {
                let user = try await loginRepo.createUser(email: email, password: password)
                DispatchQueue.main.async { [weak self] in
                    self?.user = user
                }
                completion(true, "")
            } catch {
                print("Error:", error)
                completion(false, error.localizedDescription)
            }
            
        }
    }
    
    func sendEmailVerification(completion: @escaping ((Bool) -> Void)) {
        Task(priority: .medium) { [loginRepo] in
            do {
                try await loginRepo.sendEmailVerification(completion: completion)
            } catch {
                print("Error:", error)
            }
            
        }
    }
    
    func successfulRegistration() {
        guard let user = self.user else { return }
        let dbUser = DBUser(uid: user.uid, email: email, fullName: fullName, phoneNumber: phoneNumber, isAnonymous: user.isAnonymous, paymentMethods: paymentMethods, defaultPaymentMethod: paymentMethods.first)
        Task(priority: .medium) {
            try await userRepo.createUserInDB(user: dbUser)
            authenticationRepo.success()
        }
    }
    
    func updateNameInDB() async throws {
        if !fullName.isEmpty {
            try await userRepo.editUserNameInDB(name: fullName)
        }
    }
    
    func updatePhoneNumberInDB() async throws {
        if !phoneNumber.isEmpty {
            try await userRepo.editPhoneNumberInDB(phoneNumber: phoneNumber)
        }
    }
    
    func createNameAndPhoneNumberPublisher() -> AnyPublisher<String, Never> {
        var namePublisher: AnyPublisher<String, Never> {
            $fullName
                .eraseToAnyPublisher()
        }
        
        var phoneNumberPublisher: AnyPublisher<String, Never> {
            $phoneNumber
                .eraseToAnyPublisher()
        }
        
        var nameAndPhoneNumberPublisher: AnyPublisher<String, Never> {
            Publishers.CombineLatest(namePublisher, phoneNumberPublisher)
                .map {
                    if $1 == "" {
                        return $0
                    } else if $0 == "" {
                        return $1
                    } else if $0 != "" && $1 != "" {
                        return "\($0), \($1)"
                    } else {
                        return ""
                    }
                }
                .eraseToAnyPublisher()
        }
        
        return nameAndPhoneNumberPublisher
    }

    var passwordPublisher: AnyPublisher<Bool, Never> {
        $showPassword
            .eraseToAnyPublisher()
    }
    
    var retypedPasswordPublisher: AnyPublisher<Bool, Never> {
        $showRetyped
            .eraseToAnyPublisher()
    }
    
    var isValidEmailPublisher: AnyPublisher<Bool, Never> {
        $email
            .map { $0.isValidEmail }
            .eraseToAnyPublisher()
    }
    
    var isValidPhoneNumberPublisher: AnyPublisher<Bool, Never> {
        $phoneNumber
            .map { $0.contains("+") && $0.count >= 11 }
            .eraseToAnyPublisher()
    }
    
    var isValidPasswordPublisher: AnyPublisher<Bool, Never> {
        $password
            .map { !$0.isEmpty && $0.count >= 6 }
            .eraseToAnyPublisher()
    }
    
    var isValidRetypedPasswordPublisher: AnyPublisher<Bool, Never> {
        $retypedPassword
            .map { !$0.isEmpty && $0.count >= 6 }
            .eraseToAnyPublisher()
    }
    
    var isSignUpValid: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isValidPasswordPublisher, isValidRetypedPasswordPublisher)
            .map { $0 == $1 }
            .eraseToAnyPublisher()
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

