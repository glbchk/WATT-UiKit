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
    var fullName: String?
    var phoneNumber: String?
    var photoURL: String?
    var dateCreated: Date = Date()
    let isAnonymous: Bool
//    var location: UserLocation?
    
    init(user: AppUser) {
        self.uid = user.uid
        self.email = user.email
        self.fullName = user.fullName
        self.phoneNumber = user.phoneNumber
        self.photoURL = user.photoURL
        self.isAnonymous = user.isAnonymous
//        self.location = nil
    }
    
    init(
        uid: String,
        email: String? = nil,
        fullName: String? = nil,
        phoneNumber: String? = nil,
        photoURL: String? = nil,
        isAnonymous: Bool
    ) {
        self.uid = uid
        self.email = email
        self.fullName = fullName
        self.phoneNumber = phoneNumber
        self.photoURL = photoURL
        self.isAnonymous = isAnonymous
    }
    
    enum CodingKeys: String, CodingKey {
        case uid, email
        case fullName = "full_name"
        case phoneNumber = "phone_number"
        case dateCreated = "date_created"
        case photoURL = "photo_url"
        case isAnonymous = "is_anonymous"
    }
    
}
