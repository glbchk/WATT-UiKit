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
    
    @Published var cardProvider: PaymentMethodRowType? = nil
    @Published var cardName: String = ""
    @Published var cardNumber: String = ""
    @Published var expiry: String = ""
    @Published var cvv: String = ""
    @Published var paymentMethods: [PaymentMethod] = [
//        PaymentMethod(provider: .visa, cardName: "rlgjnelgnkle", cardNumber: "37863474673698", expiryDate: "12/25", cvv: "123"),
//        PaymentMethod(provider: .mastercard, cardName: "ekjgnlteh;rt", cardNumber: "47863474673698", expiryDate: "12/25", cvv: "123")
    ]
    @Published var defaultPaymentMethod: Bool = false
    
    @Published var user: AppUser?
    
    @Published var showPassword = false
    @Published var showRetyped = false
    
    @Published var showCvv = false
    
    @Published var fakeDataTable = [
        "Audi X8",
        "BMW M9",
        "Tesla Sport Shos..."
    ]
    
    private let authenticationRepo: AuthenticationRepository
    private let loginRepo: LoginRepository
    private var userRepo: UserRepository
    
    init(dependencies: Resolver) {
        authenticationRepo = dependencies.resolve(AuthenticationRepository.self)!
        loginRepo = dependencies.resolve(LoginRepository.self)!
        userRepo = dependencies.resolve(UserRepository.self)!
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
        let dbUser = DBUser(uid: user.uid, email: email, fullName: fullName, phoneNumber: phoneNumber, isAnonymous: user.isAnonymous)
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
    
    func savePaymentMethod(paymentMethod: PaymentMethod) {
        cardProvider = cardNumber.checkBankProvider(number: cardNumber)
        
        let paymentMethod = PaymentMethod(provider: cardProvider, cardName: cardName, cardNumber: cardNumber, expiryDate: expiry, cvv: cvv, isDefault: defaultPaymentMethod)
        paymentMethods.append(paymentMethod)
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
    
    var cvvPublisher: AnyPublisher<Bool, Never> {
        $showCvv
            .eraseToAnyPublisher()
    }
    
    func createPaymentMethodPublisher() -> AnyPublisher<String, Never> {
        
        var cardNamePublisher: AnyPublisher<String, Never> {
            $cardName
                .eraseToAnyPublisher()
        }
        
        var cardNumberPublisher: AnyPublisher<String, Never> {
            $cardNumber
                .eraseToAnyPublisher()
        }
        
        var expiryPublisher: AnyPublisher<String, Never> {
            $expiry
                .eraseToAnyPublisher()
        }
        
        var cvvPublisher: AnyPublisher<String, Never> {
            $cvv
                .eraseToAnyPublisher()
        }
        
        var paymentMethodPublisher: AnyPublisher<String, Never> {
            Publishers.CombineLatest4(cardNamePublisher, cardNumberPublisher, expiryPublisher, cvvPublisher)
                .map { cardName, cardNumber, expiry, cvv in
                    if !cardName.isEmpty {
                        return "\(cardName)"
                    } else if !cardNumber.isEmpty {
                        return "\(cardNumber)"
                    } else if !expiry.isEmpty {
                        return "\(expiry)"
                    } else if !cvv.isEmpty && cvv.count == 3 {
                        return "\(cvv)"
                    } else {
                        return "Card data is invalid"
                    }
                }
                .eraseToAnyPublisher()
        }
        
        return paymentMethodPublisher
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

extension String {
    
    func checkBankProvider(number: String) -> PaymentMethodRowType {
        var result = PaymentMethodRowType.americanExpress
        
        if number.prefix(2) == "34" || number.prefix(2) == "37" {
            result = PaymentMethodRowType.americanExpress
        } else if number.prefix(1) == "4" {
            result = PaymentMethodRowType.visa
            if number.prefix(6) == "483312" {
                result = PaymentMethodRowType.chase
            }
        } else if number.prefix(1) == "5" {
            result = PaymentMethodRowType.mastercard
        } else if number.prefix(1) == "6" {
            result = PaymentMethodRowType.discover
        }
        
        return result
    }
    
}
