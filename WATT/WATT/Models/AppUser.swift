//
//  AppUserModel.swift
//  WATT
//
//  Created by Glib Galchenko on 10/01/24.
//

import Foundation
import FirebaseAuth

struct AppUser: Codable {
    let uid: String
    let email: String
    var fullName: String
    var phoneNumber: String?
    var photoURL: String?
//    var location: UserLocation?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email ?? ""
        self.fullName = user.displayName ?? ""
        self.phoneNumber = user.phoneNumber
        self.photoURL = user.photoURL?.absoluteString
//        self.location = nil
    }
    
    
}
