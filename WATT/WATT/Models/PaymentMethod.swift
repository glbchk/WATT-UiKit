//
//  PaymentMethod.swift
//  WATT
//
//  Created by Glib Galchenko on 01/03/24.
//

import Foundation
import UIKit

struct PaymentMethod: Identifiable, Codable {
    var id = UUID()
    let provider: PaymentMethodRowType?
    let cardName: String?
    let cardNumber: String?
    let expiryDate: String?
    let cvv: String?
    var isDefault: Bool?
    
    init(
        provider: PaymentMethodRowType? = nil,
        cardName: String?,
        cardNumber: String?,
        expiryDate: String?,
        cvv: String?,
        isDefault: Bool? = nil
    ) {
        self.provider = provider
        self.cardName = cardName
        self.cardNumber = cardNumber
        self.expiryDate = expiryDate
        self.cvv = cvv
        self.isDefault = isDefault
    }
    
    enum CodingKeys: String, CodingKey {
        case provider, cvv
        case cardName = "card_name"
        case cardNumber = "card_number"
        case expiryDate = "expiry_date"
        case isDefault = "is_default"
    }
}
