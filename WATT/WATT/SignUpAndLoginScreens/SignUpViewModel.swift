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
    @Published var showPassword = false
    @Published var state: TextFieldState = .none
    
    @Published var user: AppUser?
    
    private let authenticationRepo: AuthenticationRepository
    
    init(dependencies: Resolver) {
        authenticationRepo = dependencies.resolve(AuthenticationRepository.self)!
    }
    
    @objc func actionButton(_ sender: UIButton!) {
        print("Button tapped")
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
    // 5
    var isSubmitEnabled: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isValidUsernamePublisher, isValidPasswordPublisher)
            .map { $0 && $1 }
            .eraseToAnyPublisher()
    }
    // 6
    func submitLogin() {
        state = .loading
        // hardcoded 2 seconds delay, to simulate request
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
            guard let self = self else { return }
            // 7
            if self.isCorrectLogin() {
                self.state = .success
            } else {
                self.state = .failed
            }
        }
    }
    
    func isCorrectLogin() -> Bool {
        // hardcoded example
        return email == "john@example.com" && password == "12345"
    }
    
}


extension String {
    // 8
    var isValidEmail: Bool {
        return NSPredicate(
            format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        )
        .evaluate(with: self)
    }
}
