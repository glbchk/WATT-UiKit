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
    @Published var isCardNumberValid: String = ""
    @Published var expiry: String = ""
    @Published var cvv: String = ""
    @Published var defaultPaymentMethod: Bool = false
    
    @Published var showCvv = false
//    @Published var isCardValidated = false
    
    @Published var selectedPaymentMethod: PaymentMethod?
    
//    @Published var addedPaymentMethods: [PaymentMethod] = [
//        PaymentMethod(provider: .americanExpress, cardName: "rlgjnelgnkle", cardNumber: "3786347467369812", expiryDate: "12/25", cvv: "123", isDefault: true),
//        PaymentMethod(provider: .visa, cardName: "ekjgnlteh;rt", cardNumber: "4786347467369833", expiryDate: "12/25", cvv: "123", isDefault: false)
//    ]
    
    init(dependencies: Resolver) {
//        signUpViewModel = SignUpViewModel(dependencies: dependencies)
    }
    
    func savePaymentMethod(paymentMethods: [PaymentMethod]) -> [PaymentMethod] {
        var methods = paymentMethods
        
        let cardProvider = checkBankProvider(number: cardNumber)
        let savedPaymentMethod = PaymentMethod(provider: cardProvider, cardName: cardName, cardNumber: cardNumber, expiryDate: expiry, cvv: cvv, isDefault: defaultPaymentMethod)
        
        methods.append(savedPaymentMethod)
        
        if defaultPaymentMethod == true {
            for index in 0..<methods.count {
                if !methods.isEmpty && methods[index].id == savedPaymentMethod.id {
                    if methods[index].isDefault != defaultPaymentMethod {
                        methods[indexForDefaultPaymentMethod(in: methods)].isDefault = false
                        methods[index].isDefault = true
                    }
                }
            }
        } else {
            for index in 0..<methods.count {
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
    
    func isCardIsRepeating(cardNumber: String, paymentMethods: [PaymentMethod]) {
        
        if !paymentMethods.isEmpty {
            for index in 0..<paymentMethods.count {
                if paymentMethods[index].cardNumber == cardNumber {
                    isCardNumberValid = formatTextWithSpaces(text: cardNumber)
                    break
                }
            }
        }
    }
    
    func deletePaymentMethod(paymentMethods: [PaymentMethod]) -> [PaymentMethod] {
        var methods = paymentMethods
        
        for index in 0..<methods.count {
            if !methods.isEmpty {
                if methods[index].id == selectedPaymentMethod?.id {
                    methods.remove(at: index)
                }
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
            }
            if methods[index].isDefault == false && defaultPaymentMethod == false {
                methods[0].isDefault = true
            }
        }
        
        return methods
    }
    
    var cardNamePublisher: AnyPublisher<Bool, Never> {
        $cardName
            .map { cardName in
                if !cardName.isEmpty && cardName.count >= 4 {
                    return true
                } else {
                    return false
                }
            }
            .eraseToAnyPublisher()
    }

    var cardNumberPublisher: AnyPublisher<Bool, Never> {
        $cardNumber
            .map { cardNumber in
                if !cardNumber.isEmpty && cardNumber.count == 19 {
                    return true
                } else {
                    return false
                }
            }
            .eraseToAnyPublisher()
    }
    
//    var verifyCardNumberPublisher: AnyPublisher<Bool, Never> {
//        $cardNumber
//            .map { !$0.isEmpty }
//            .eraseToAnyPublisher()
//    }

    var expiryPublisher: AnyPublisher<Bool, Never> {
        $expiry
            .map { expiry in
                if !expiry.isEmpty {
                    return true
                } else {
                    return false
                }
            }
            .eraseToAnyPublisher()
    }

    var cvvPublisher: AnyPublisher<Bool, Never> {
        $cvv
            .map { cvv in
                if !cvv.isEmpty && cvv.count == 3 {
                    return true
                } else {
                    return false
                }
            }
            .eraseToAnyPublisher()
    }
    
    var cvvTogglePublisher: AnyPublisher<Bool, Never> {
        $showCvv
            .eraseToAnyPublisher()
    }
    
    var isCardDetailsValid: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest4(cardNamePublisher, cardNumberPublisher, expiryPublisher, cvvPublisher)
            .map { cardName, cardNumber, expiry, cvv in
                if cardName == true && cardNumber == true && expiry == true && cvv == true {
                    return true
                } else {
                    return false
                }
            }
            .eraseToAnyPublisher()
    }
    
    var isCardDupblicate: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($isCardNumberValid, $cardNumber)
            .map {
                if $0 == $1 {
                    return true
                } else {
                    return false
                }
            }
            .eraseToAnyPublisher()
    }
    
    var isCardValid: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isCardDetailsValid, isCardDupblicate)
            .map {
                if $0 == true {
                    if $1 == false {
                        return true
                    } else {
                        return false
                    }
                } else {
                    return false
                }
            }
            .eraseToAnyPublisher()
    }
    
    
    var isEditCardValid: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(cardNamePublisher, cvvPublisher)
            .map { cardName, cvv in
                if cardName == true, cvv == true {
                    return true
                } else {
                    return false
                }
            }
            .eraseToAnyPublisher()
    }
    
//    func createCardVerificationPublisher(paymentMethods: [PaymentMethod]) -> AnyPublisher<Bool, Never> {
//
//        for index in 0..<paymentMethods.count {
//            if !paymentMethods.isEmpty {
//                if paymentMethods[index].cardNumber == cardNumber {
//                    isCardNumberValid = cardNumber
////                    result = "The card is already added, add another card!"
//                } 
////                else {
////                    result = false
////                    result = "Card is valid!"
////                }
//            }
//        }
//        
//        var verifyCardsPublisher: AnyPublisher<Bool, Never> {
//            Publishers.CombineLatest($isCardNumberValid, $cardNumber)
//                .map {
//                    if $0 == $1 {
//                        return true
//                    } else {
//                        return false
//                    }
//                }
//                .eraseToAnyPublisher()
//        }
//        
//        return verifyCardsPublisher
//    }
    
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
    
//    func formatDateWithSlash(text: String) -> String {
//        
//        let sanitizedText = text.replacingOccurrences(of: "/", with: "")
//        
//        var formattedText = ""
//        var index = 0
//        for character in sanitizedText {
//            if index > 0 && index % 2 == 0 {
//                formattedText.append("/")
//            }
//            formattedText.append(character)
//            index += 1
//        }
//        
//        return formattedText
//    }
    
}


