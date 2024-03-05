//
//  PaymentMethodViewModel.swift
//  WATT
//
//  Created by Glib Galchenko on 03/03/24.
//

import UIKit
import Foundation
import Combine
import Swinject

class PaymentMethodViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    @Published var cardProvider: PaymentMethodRowType = .unknown
    @Published var cardName: String = ""
    @Published var cardNumber: String = ""
    @Published var expiry: String = ""
    @Published var cvv: String = ""
    @Published var defaultPaymentMethod: Bool = false
    
    @Published var showCvv = false
    
    @Published var addedPaymentMethods: [PaymentMethod] = [
//        PaymentMethod(provider: .americanExpress, cardName: "rlgjnelgnkle", cardNumber: "37863474673698", expiryDate: "12/25", cvv: "123"),
//        PaymentMethod(provider: .visa, cardName: "ekjgnlteh;rt", cardNumber: "47863474673698", expiryDate: "12/25", cvv: "123")
    ]
    
    init(dependencies: Resolver) {
//        signUpViewModel = SignUpViewModel(dependencies: dependencies)
    }
    
    func savePaymentMethod(provider bank: PaymentMethodRowType) {
        let savedPaymentMethod = PaymentMethod(provider: bank, cardName: cardName, cardNumber: cardNumber, expiryDate: expiry, cvv: cvv, isDefault: defaultPaymentMethod)
        addedPaymentMethods.append(savedPaymentMethod)
    }
    
    var cardNamePublisher: AnyPublisher<Bool, Never> {
        $cardName
            .map { !$0.isEmpty && $0.count >= 4 }
            .eraseToAnyPublisher()
    }

    var cardNumberPublisher: AnyPublisher<Bool, Never> {
        $cardNumber
            .map { !$0.isEmpty && $0.count == 16 }
            .eraseToAnyPublisher()
    }

    var expiryPublisher: AnyPublisher<Bool, Never> {
        $expiry
            .map { !$0.isEmpty && $0.count == 5 }
            .eraseToAnyPublisher()
    }

    var cvvPublisher: AnyPublisher<Bool, Never> {
        $cvv
            .map { !$0.isEmpty && $0.count == 3 }
            .eraseToAnyPublisher()
    }
    
    var isCardValid: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest4(cardNamePublisher, cardNumberPublisher, expiryPublisher, cvvPublisher)
            .map { cardName, cardNumber, expiry, cvv in
                if cardName == true, cardNumber == true, expiry == true, cvv == true {
                    return true
                } else {
                    return false
                }
            }
            .eraseToAnyPublisher()
    }
    
    func createPaymentMethodPublisher() -> AnyPublisher<String, Never> {
        
        var cardProviderPublisher: AnyPublisher<PaymentMethodRowType, Never> {
            $cardProvider
                .eraseToAnyPublisher()
        }
        
        var paymentMethodPublisher: AnyPublisher<String, Never> {
            cardProviderPublisher
                .map { _ in
                    var result: String = ""
                    
                    for method in self.addedPaymentMethods {
                        if !self.addedPaymentMethods.isEmpty {
                            result = "\(method.provider?.title ?? "") credit card"
                            if self.addedPaymentMethods.count <= 2 {
                                result += ", \(method.provider?.title ?? "") credit card"
                            } else if self.addedPaymentMethods.count >= 3 {
                                
                            }
                            return result
                        }
                    }
                    return result
                }
                .eraseToAnyPublisher()
        }
        
        return paymentMethodPublisher
    }
    
    func checkBankProvider(number: String) -> PaymentMethodRowType {
        
        if number.prefix(2) == "34" || number.prefix(2) == "37" {
            return PaymentMethodRowType.americanExpress
        } else if number.prefix(1) == "4" {
            if number.prefix(6) == "483312" {
                return PaymentMethodRowType.chase
            }
            return PaymentMethodRowType.visa
        } else if number.prefix(1) == "5" {
            return PaymentMethodRowType.mastercard
        } else if number.prefix(1) == "6" {
            return PaymentMethodRowType.discover
        } else {
            return PaymentMethodRowType.unknown
        }

    }
    
}


