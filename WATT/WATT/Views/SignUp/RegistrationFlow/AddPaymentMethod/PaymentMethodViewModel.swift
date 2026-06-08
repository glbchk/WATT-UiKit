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
    
    @Published var addedPaymentMethods: [PaymentMethod] = [
        PaymentMethod(provider: .americanExpress, cardName: "rlgjnelgnkle", cardNumber: "3786347467369812", expiryDate: "12/25", cvv: "123", isDefault: true),
        PaymentMethod(provider: .visa, cardName: "ekjgnlteh;rt", cardNumber: "4786347467369833", expiryDate: "12/25", cvv: "123", isDefault: false),
        PaymentMethod(provider: .americanExpress, cardName: "rlgjnelgnkle", cardNumber: "3786347467369812", expiryDate: "12/25", cvv: "123", isDefault: true),
        PaymentMethod(provider: .visa, cardName: "ekjgnlteh;rt", cardNumber: "4786347467369833", expiryDate: "12/25", cvv: "123", isDefault: false),
        PaymentMethod(provider: .americanExpress, cardName: "rlgjnelgnkle", cardNumber: "3786347467369812", expiryDate: "12/25", cvv: "123", isDefault: true),
        PaymentMethod(provider: .visa, cardName: "ekjgnlteh;rt", cardNumber: "4786347467369833", expiryDate: "12/25", cvv: "123", isDefault: false)
    ]
    
    init(dependencies: Resolver) {
//        signUpViewModel = SignUpViewModel(dependencies: dependencies)
    }
    
    func savePaymentMethod() {
        
        cardProvider = checkBankProvider(number: cardNumber)
        let savedPaymentMethod = PaymentMethod(provider: cardProvider, cardName: cardName, cardNumber: cardNumber, expiryDate: expiry, cvv: cvv, isDefault: defaultPaymentMethod)
        
        addedPaymentMethods.append(savedPaymentMethod)
        
        if defaultPaymentMethod == true {
            for index in 0..<addedPaymentMethods.count {
                if !addedPaymentMethods.isEmpty && addedPaymentMethods[index].id == savedPaymentMethod.id {
                    if addedPaymentMethods[index].isDefault != defaultPaymentMethod {
                        addedPaymentMethods[indexForDefaultPaymentMethod()].isDefault = false
                        addedPaymentMethods[index].isDefault = true
                    }
                }
            }
        } else {
            for index in 0..<addedPaymentMethods.count {
                if addedPaymentMethods[index].isDefault == false {
                    addedPaymentMethods[0].isDefault = true
                }
            }
        }
    }
    
    func defaultMethodToggle() {
        
        for index in 0..<addedPaymentMethods.count {
            if addedPaymentMethods[index].isDefault == true {
                addedPaymentMethods[index].isDefault = false
            }
        }
    }
    
    func deletePaymentMethod() {
        
        for index in 0..<addedPaymentMethods.count {
            if !addedPaymentMethods.isEmpty {
                if addedPaymentMethods[index].id == selectedPaymentMethod?.id {
                    addedPaymentMethods.remove(at: index)
                    
                    if addedPaymentMethods.count >= 1 {
                        if addedPaymentMethods[0].isDefault == false {
                            addedPaymentMethods[0].isDefault = true
                        }
                        break
                    }
                }
            }
        }
    }
    
    func indexForDefaultPaymentMethod() -> Int {
        var indexResult = 0
        
        for index in 0..<addedPaymentMethods.count {
            if addedPaymentMethods[index].isDefault == true {
                indexResult = index
            }
        }
        
        return indexResult

    }
    
    func editPaymentMethod() {
        
        for index in 0..<addedPaymentMethods.count {
            if addedPaymentMethods[index].id == selectedPaymentMethod?.id {
                if addedPaymentMethods[index].cardName != cardName {
                    addedPaymentMethods[index].cardName = cardName
                }
                if addedPaymentMethods[index].cvv != cvv {
                    addedPaymentMethods[index].cvv = cvv
                }
                if defaultPaymentMethod == true {
                    addedPaymentMethods[indexForDefaultPaymentMethod()].isDefault = false
                    addedPaymentMethods[index].isDefault = true
                } else {
                    addedPaymentMethods[indexForDefaultPaymentMethod()].isDefault = false
                    addedPaymentMethods[0].isDefault = true
                }
            }
        }
    }
    
    var cardNamePublisher: AnyPublisher<Result<Bool, TFError.PaymentMethod>, Never> {
        $cardName
            .debounce(for: .seconds(0.7), scheduler: RunLoop.main)
            .map { $0.isEmpty ? .success(false) : ($0.count >= 4 ? .success(true) : .failure(.invalidCardNameLength)) }
            .eraseToAnyPublisher()
    }

    var cardNumberPublisher: AnyPublisher<Result<Bool, TFError.PaymentMethod>, Never> {
        $cardNumber
            .debounce(for: .seconds(0.7), scheduler: RunLoop.main)
            .map { $0.isEmpty ? .success(false) : ($0.count == 19 ? .success(true) : .failure(.invalidCardNumberLength)) }
            .eraseToAnyPublisher()
    }

    var expiryPublisher: AnyPublisher<Result<Bool, TFError.PaymentMethod>, Never> {
        $expiry
            .debounce(for: .seconds(0.7), scheduler: RunLoop.main)
            .map { $0.count == 5 ? .success(true) : .failure(.invalidExpiryDate) }
            .eraseToAnyPublisher()
    }

    var cvvPublisher: AnyPublisher<Result<Bool, TFError.PaymentMethod>, Never> {
        $cvv
            .debounce(for: .seconds(0.7), scheduler: RunLoop.main)
            .map { $0.isEmpty ? .success(false) : ($0.count == 3 ? .success(true) : .failure(.invalidCvvLength)) }
            .eraseToAnyPublisher()
    }
    
    var cvvTogglePublisher: AnyPublisher<Bool, Never> {
        $showCvv
            .eraseToAnyPublisher()
    }
    
    var isCardDetailsValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest4(cardNamePublisher, cardNumberPublisher, expiryPublisher, cvvPublisher)
            .map { cardName, cardNumber, expiry, cvv in
                if cardName == .success(true) && cardNumber == .success(true) && expiry == .success(true) && cvv == .success(true) {
                    return true
                } else {
                    return false
                }
            }
            .eraseToAnyPublisher()
    }
    
    var isCardDuplicatePublisher: AnyPublisher<Result<Bool, TFError.PaymentMethod>, Never> {
        $cardNumber
            .map {
                
                if !self.addedPaymentMethods.isEmpty {
                    for index in 0..<self.addedPaymentMethods.count {
                        if self.addedPaymentMethods[index].cardNumber == $0 {
                            return .failure(.cardIsDuplicated)
                        }
                    }
                    
                } else {
                    return .success(true)
                }
                
                return .success(true)
            }
            .eraseToAnyPublisher()
    }
    
    var isCardValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isCardDetailsValidPublisher, isCardDuplicatePublisher)
            .map {
                if $0 == true && $1 == .success(true) {
                    return true
                } else {
                    return false
                }
            }
            .eraseToAnyPublisher()
    }
    
    var isEditCardValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(cardNamePublisher, cvvPublisher)
            .map {
                if $0 == .success(true) && $1 == .success(true) {
                    return true
                } else {
                    return false
                }
            }
            .eraseToAnyPublisher()
    }
    
    func createPaymentMethodPublisher() -> AnyPublisher<String, Never> {
        
        var paymentMethodPublisher: AnyPublisher<String, Never> {
            $addedPaymentMethods
                .map { paymentMethods in
                    if !paymentMethods.isEmpty {
                        let cardNumber = self.hideCardNumbers(card: paymentMethods[0].cardNumber)
                        let provider = paymentMethods[0].provider?.title
                        
                        return "\(cardNumber), \(provider ?? "credit card")"
                    } else {
                        return ""
                    }
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
    
    func hideCardNumbers(card number: String) -> String {
        var result = ""
        
        let firstTwoDigits = number.prefix(2)
        let lastFourDigits = number.suffix(4)
        result = "\(firstTwoDigits)****\(lastFourDigits)"
        
        return result
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
