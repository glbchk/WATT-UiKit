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
    
    @Published var selectedPaymentMethod: PaymentMethod?
    
//    @Published var addedPaymentMethods: [PaymentMethod] = [
//        PaymentMethod(provider: .americanExpress, cardName: "rlgjnelgnkle", cardNumber: "3786347467369812", expiryDate: "12/25", cvv: "123", isDefault: true),
//        PaymentMethod(provider: .visa, cardName: "ekjgnlteh;rt", cardNumber: "4786347467369833", expiryDate: "12/25", cvv: "123", isDefault: false)
//    ]
    
    init(dependencies: Resolver) {
//        signUpViewModel = SignUpViewModel(dependencies: dependencies)
    }
    
    func deletePaymentMethod(paymentMethods: [PaymentMethod]) -> [PaymentMethod] {
        var methods = paymentMethods
        
        for index in 0..<methods.count {
            if methods[index].id == selectedPaymentMethod?.id {
                methods.remove(at: index)
            }
        }
        
        return methods
    }
    
    func indexForDefaultPaymentMethod(in paymentMethods: [PaymentMethod]) -> Int {
        var indexResult = 0
        
        for index in 0..<paymentMethods.count {
            if paymentMethods[index].isDefault == true {
                indexResult = index
            }
        }
        
        return indexResult

    }
    
    func editPaymentMethod(paymentMethods: [PaymentMethod]) -> [PaymentMethod] {
        var methods = paymentMethods
        
        for index in 0..<methods.count {
            if methods[index].id == selectedPaymentMethod?.id {
                if methods[index].cardName != cardName{
                    methods[index].cardName = cardName
                }
                if methods[index].cvv != cvv {
                    methods[index].cvv = cvv
                }
                if methods[index].isDefault != defaultPaymentMethod {
                    methods[indexForDefaultPaymentMethod(in: methods)].isDefault = false
                    methods[index].isDefault = defaultPaymentMethod
                }
                if methods[index].isDefault == false {
                    methods[0].isDefault = true
                }
            }
        }
        
        return methods
    }
    
    func defaultMethodToggle(paymentMethods: [PaymentMethod]) -> [PaymentMethod] {
        var methods = paymentMethods
        
        for index in 0..<methods.count {
            if methods[index].isDefault == true {
                methods[index].isDefault = false
            }
        }
        
        return methods
    }
    
    func savePaymentMethod(paymentMethods: [PaymentMethod]) -> [PaymentMethod] {
        var methods = paymentMethods
        
        let cardProvider = checkBankProvider(number: cardNumber)
        let savedPaymentMethod = PaymentMethod(provider: cardProvider, cardName: cardName, cardNumber: cardNumber, expiryDate: expiry, cvv: cvv, isDefault: defaultPaymentMethod)
        
        methods.append(savedPaymentMethod)
        
        for index in 0..<methods.count {
            if methods[index].id == savedPaymentMethod.id {
                if defaultPaymentMethod == false {
                    methods[index].isDefault = true
                }
            }
        }
        
        return methods
    }
    
    var cardNamePublisher: AnyPublisher<Bool, Never> {
        $cardName
            .map { !$0.isEmpty && $0.count >= 4 }
            .eraseToAnyPublisher()
    }

    var cardNumberPublisher: AnyPublisher<Bool, Never> {
        $cardNumber
            .map { !$0.isEmpty && $0.count == 19 }
            .eraseToAnyPublisher()
    }

    var expiryPublisher: AnyPublisher<Bool, Never> {
        $expiry
            .map { !$0.isEmpty && $0.count == 5 }
            .eraseToAnyPublisher()
    }

    var cvvPublisher: AnyPublisher<Bool, Never> {
        $showCvv
            .eraseToAnyPublisher()
    }
    
    var isCardValid: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest4(cardNamePublisher, cardNumberPublisher, expiryPublisher, $cvv)
            .map { cardName, cardNumber, expiry, cvv in
                if cardName == true, cardNumber == true, expiry == true, cvv.count == 3 {
                    return true
                } else {
                    return false
                }
            }
            .eraseToAnyPublisher()
    }
    
    func createPaymentMethodPublisher(methods: [PaymentMethod]) -> AnyPublisher<String, Never> {
        
        var paymentMethodPublisher: AnyPublisher<String, Never> {
            $cardProvider
                .map { _ in
                    var result: String = ""
                    
                    for method in methods {
                        if !methods.isEmpty {
                            result = "\(method.provider?.title ?? "") credit card"
                            if methods.count <= 2 {
                                result += ", \(method.provider?.title ?? "") credit card"
                            } else if methods.count >= 3 {
                                
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
    
    func formatTextWithSpaces(text: String) -> String {
        
        let sanitizedText = text.replacingOccurrences(of: " ", with: "")
        
        var formattedText = ""
        var index = 0
        for character in sanitizedText {
            if index > 0 && index % 4 == 0 {
                formattedText.append(" ")
            }
            formattedText.append(character)
            index += 1
        }
        
        return formattedText
    }
    
    func formatDateWithSlash(text: String) -> String {
        
        let sanitizedText = text.replacingOccurrences(of: "/", with: "")
        
        var formattedText = ""
        var index = 0
        for character in sanitizedText {
            if index > 0 && index % 2 == 0 {
                formattedText.append("/")
            }
            formattedText.append(character)
            index += 1
        }
        
        return formattedText
    }
    
}


