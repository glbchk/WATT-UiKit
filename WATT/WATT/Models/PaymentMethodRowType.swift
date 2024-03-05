//
//  PaymentMethodRowType.swift
//  WATT
//
//  Created by Glib Galchenko on 01/03/24.
//

import UIKit

enum PaymentMethodRowType: String, Codable {
    case americanExpress
    case chase
    case discover
    case mastercard
    case visa
    case unknown
    
    var title: String {
        switch self {
            case .americanExpress:
                return "American Express"
            case .chase:
                return "Chase"
            case .discover:
                return "Discover"
            case .mastercard:
                return "Mastercard"
            case .visa:
                return "Visa"
            case .unknown:
                return "Unknown payment method"
        }
    }
    
    var icon: UIImage? {
        switch self {
            case .americanExpress:
                return Asset.Icons.BankCards.americanExpress
            case .chase:
                return Asset.Icons.BankCards.chase
            case .discover:
                return Asset.Icons.BankCards.discover
            case .mastercard:
                return Asset.Icons.BankCards.mastercard
            case .visa:
                return Asset.Icons.BankCards.visa
            case .unknown:
                return Asset.Icons.BankCards.unknown
        }
        
    }
}
