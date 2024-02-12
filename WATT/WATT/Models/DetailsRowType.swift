//
//  DetailsRowType.swift
//  WATT
//
//  Created by Stas Boiko on 03.02.2024.
//

import UIKit

enum DetailsRowType {
    case nameAndPhoneNumber, car, paymentMethod
    
    var title: String {
        switch self {
        case .nameAndPhoneNumber:
            return "Add your name & phone number"
        case .car:
            return "Add your car"
        case .paymentMethod:
            return "Add payment method"
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .nameAndPhoneNumber:
            return Asset.Icons.account
        case .car:
            return Asset.Icons.car
        case .paymentMethod:
            return Asset.Icons.card
        }
    }
}
