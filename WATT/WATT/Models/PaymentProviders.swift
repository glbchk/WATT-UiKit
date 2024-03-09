//
//  PaymentProviders.swift
//  WATT
//
//  Created by Glib Galchenko on 01/03/24.
//

import UIKit

enum PaymentProviders: String, Codable {
    case card, cash, unknown
    
    var title: String {
        switch self {
            case .card:
                return "Card"
            case .cash:
                return "Cash"
            case .unknown:
                return "None"
        }
    }
    
    var icon: UIImage? {
        switch self {
            case .card:
                return Asset.Icons.card
            case .cash:
                return Asset.Icons.cash
            case .unknown:
                return Asset.Icons.unknown
        }
    }
}
