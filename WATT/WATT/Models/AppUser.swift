//
//  AppUserModel.swift
//  WATT
//
//  Created by Glib Galchenko on 10/01/24.
//

import Foundation
import Firebase

struct AppUser: Codable {
    let uid: String
    let email: String?
//    let isEmailConfirmed: Bool?
    var fullName: String?
    var phoneNumber: String?
    var photoURL: String?
    let dateCreated: Date
    let isAnonymous: Bool
//    var location: UserLocation?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email ?? ""
//        self.isEmailConfirmed = user.isEmailVerified
        self.fullName = user.displayName ?? ""
        self.phoneNumber = user.phoneNumber
        self.photoURL = user.photoURL?.absoluteString
        self.dateCreated = Date()
        self.isAnonymous = user.isAnonymous
//        self.location = nil
    }
    
}
