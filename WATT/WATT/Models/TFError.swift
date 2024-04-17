//
//  TFError.swift
//  WATT
//
//  Created by Stas Boiko on 20.03.2024.
//

import Foundation

enum TFError: Error {
    
    enum Registration: Error {
        case invalidEmailFormat
        case invalidPasswordLength
        case invalidRetypedPassword
        case requiredField
        
        var description: String {
            switch self {
            case .invalidEmailFormat:
                "Invalid email format"
            case .invalidPasswordLength:
                "Password should contain at least 6 characters"
            case .invalidRetypedPassword:
                "This field must match password field"
            case .requiredField:
                "This field is required"
            }
        }
    }
    
    enum PaymentMethod: Error {
        case invalidCardNameLength
        case invalidCardNumberLength
        case invalidExpiryDate
        case invalidCvvLength
        case cardIsDuplicated
        
        var description: String {
            switch self {
            case .invalidCardNameLength:
                "Card name should have at least 4 symbols!"
            case .invalidCardNumberLength:
                "Card number is not 16 digits!"
            case .invalidExpiryDate:
                "Date isn't chosen!"
            case .invalidCvvLength:
                "Should be 3 digits!"
            case .cardIsDuplicated:
                "The card is already added, add another card!"
            }
        }
    }
}
