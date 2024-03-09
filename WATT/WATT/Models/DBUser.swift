//
//  DBUser.swift
//  WATT
//
//  Created by Glib Galchenko on 03/02/24.
//

import Foundation
import Firebase

struct DBUser: Codable {
    let uid: String
    var email: String?
//    var isEmailConfirmed: Bool?
    var fullName: String?
    var phoneNumber: String?
    var photoURL: String?
    var dateCreated: Date = Date()
    let isAnonymous: Bool
    var paymentMethods: [PaymentMethod]?
    var defaultPaymentMethod: PaymentMethod?
//    var location: UserLocation?
    
    init(user: AppUser) {
        self.uid = user.uid
        self.email = user.email
//        self.isEmailConfirmed = user.isEmailConfirmed
        self.fullName = user.fullName
        self.phoneNumber = user.phoneNumber
        self.photoURL = user.photoURL
        self.isAnonymous = user.isAnonymous
        self.paymentMethods = [.init(provider: .americanExpress, cardName: "", cardNumber: "", expiryDate: "", cvv: "", isDefault: false)]
        self.defaultPaymentMethod = paymentMethods?.first
//        self.location = nil
    }
    
    init(
        uid: String,
        email: String? = nil,
        fullName: String? = nil,
        phoneNumber: String? = nil,
        photoURL: String? = nil,
        isAnonymous: Bool,
        paymentMethods: [PaymentMethod]? = nil,
        defaultPaymentMethod: PaymentMethod? = nil
    ) {
        self.uid = uid
        self.email = email
        self.fullName = fullName
        self.phoneNumber = phoneNumber
        self.photoURL = photoURL
        self.isAnonymous = isAnonymous
        self.paymentMethods = paymentMethods
        self.defaultPaymentMethod = defaultPaymentMethod
    }
    
    enum CodingKeys: String, CodingKey {
        case uid, email
//        case isEmailConfirmed = "is_email_confirmed"
        case fullName = "full_name"
        case phoneNumber = "phone_number"
        case dateCreated = "date_created"
        case photoURL = "photo_url"
        case isAnonymous = "is_anonymous"
        case paymentMethods = "payment_methods"
        case defaultPaymentMethod = "default_payment_method"
    }
    
}
