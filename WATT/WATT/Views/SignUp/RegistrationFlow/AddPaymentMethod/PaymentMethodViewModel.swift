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
    @Published var isExpiryDateChanged = false
    
    @Published var selectedPaymentMethod: PaymentMethod?
    
    @Published var addedPaymentMethods: [PaymentMethod] = [
//        PaymentMethod(provider: .americanExpress, cardName: "rlgjnelgnkle", cardNumber: "3786347467369812", expiryDate: "12/25", cvv: "123", isDefault: true),
//        PaymentMethod(provider: .visa, cardName: "ekjgnlteh;rt", cardNumber: "4786347467369833", expiryDate: "12/25", cvv: "123", isDefault: false)
    ]
    
    init(dependencies: Resolver) {
//        signUpViewModel = SignUpViewModel(dependencies: dependencies)
    }
    
    func savePaymentMethod() {
        
        let cardProvider = checkBankProvider(number: cardNumber)
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
                    if addedPaymentMethods[index].isDefault == true {
                        addedPaymentMethods[0].isDefault = true
                    }
                    addedPaymentMethods.remove(at: index)
                    break
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
                if addedPaymentMethods[index].cardName != cardName{
                    addedPaymentMethods[index].cardName = cardName
                }
                if addedPaymentMethods[index].cvv != cvv {
                    addedPaymentMethods[index].cvv = cvv
                }
                if addedPaymentMethods[index].isDefault != defaultPaymentMethod {
                    addedPaymentMethods[indexForDefaultPaymentMethod()].isDefault = false
                    addedPaymentMethods[index].isDefault = defaultPaymentMethod
                }
            }
            if addedPaymentMethods[index].isDefault == false && defaultPaymentMethod == false {
                addedPaymentMethods[0].isDefault = true
            }
        }
    }
    
    var cardNamePublisher: AnyPublisher<Bool, Never> {
        $cardName
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .map { cardName in
                if cardName.count >= 4 {
                    return true
                } else {
                    return false
                }
            }
            .eraseToAnyPublisher()
    }

    var cardNumberPublisher: AnyPublisher<Bool, Never> {
        $cardNumber
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .map { cardNumber in
                if cardNumber.count == 19 {
                    return true
                } else {
                    return false
                }
            }
            .eraseToAnyPublisher()
    }

//    var expiryPublisher: AnyPublisher<Bool, Never> {
//        $expiry
//            .map { expiry in
//                if !expiry.isEmpty {
//                    return true
//                } else {
//                    return false
//                }
//            }
//            .eraseToAnyPublisher()
//    }

    var cvvPublisher: AnyPublisher<Bool, Never> {
        $cvv
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .map { cvv in
                if cvv.count == 3 {
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
    
    var isCardDetailsEmptyPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest4($cardName, $cardNumber, $expiry, $cvv)
            .map { cardName, cardNumber, expiry, cvv in
                if cardName.isEmpty && cardNumber.isEmpty && expiry.isEmpty && cvv.isEmpty {
                    return true
                } else {
                    return false
                }
            }
            .eraseToAnyPublisher()
    }
    
    var isCardDetailsValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest4(cardNamePublisher, cardNumberPublisher, $expiry, cvvPublisher)
            .map { cardName, cardNumber, expiry, cvv in
                if cardName == true && cardNumber == true && !expiry.isEmpty && cvv == true {
                    return true
                } else {
                    return false
                }
            }
            .eraseToAnyPublisher()
    }
    
    var isCardDuplicatePublisher: AnyPublisher<Bool, Never> {
        $cardNumber
            .map {
                var result = false
                
                for index in 0..<self.addedPaymentMethods.count {
                    if self.addedPaymentMethods[index].cardNumber == $0 {
                        result = true
                        break
                    } else {
                        result = false
                    }
                }
                
                return result
            }
            .eraseToAnyPublisher()
    }
    
    var isCardValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isCardDetailsValidPublisher, isCardDuplicatePublisher)
            .map {
                if $0 == true && $1 == false {
                    return true
                } else {
                    return false
                }
            }
            .eraseToAnyPublisher()
    }
    
    
    var isEditCardValidPublisher: AnyPublisher<Bool, Never> {
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
    
    func createPaymentMethodPublisher() -> AnyPublisher<String, Never> {
        
        var paymentMethodPublisher: AnyPublisher<String, Never> {
            $cardProvider
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


