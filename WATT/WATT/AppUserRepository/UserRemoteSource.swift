//
//  UserRemoteSource.swift
//  WATT
//
//  Created by Glib Galchenko on 29/01/24.
//

import Foundation

protocol UserRemoteSource {
    func createAnonymousUserInDB(user: DBUser) async throws
    func createUserInDB(user: DBUser) async throws
    func getUserFromDB() async throws -> DBUser
    func checkIfUserExist(user: AppUser, completion: @escaping ((Bool) -> Void))
    func editUserNameInDB(name: String) async throws
    func editPhoneNumberInDB(phoneNumber: String) async throws
}

final class UserRemoteSourceImpl: UserRemoteSource {
    
    private var firebaseManager = FirebaseManager()
    
    func createAnonymousUserInDB(user: DBUser) async throws {
        try await firebaseManager.createAnonymousUserInDB(user: user)
    }
    
    func createUserInDB(user: DBUser) async throws {
        try await firebaseManager.createUserInDB(user: user)
    }
    
    func getUserFromDB() async throws -> DBUser {
        return try await firebaseManager.getUserFromDB()
    }
    
    func checkIfUserExist(user: AppUser, completion: @escaping ((Bool) -> Void)) {
        firebaseManager.checkIfUserExists(user: user, completion: completion)
    }
    
    func editUserNameInDB(name: String) async throws {
        try await firebaseManager.editUserNameInDB(name: name)
    }
    
    func editPhoneNumberInDB(phoneNumber: String) async throws {
        try await firebaseManager.editPhoneNumberInDB(phoneNumber: phoneNumber)
    }
    
//    func editUserNameInDB(name: String) async throws {
//        guard let uid = authentication.currentUser?.uid else { return }
//        
//        try await firestore.collection(FirebaseConstants.users).document(uid).updateData([
//            "name" : name
//        ])
//    }
//    
//    func editPhoneNumberInDB(phoneNumber: String) async throws {
//        guard let uid = authentication.currentUser?.uid else { return }
//        
//        try await firestore.collection(FirebaseConstants.users).document(uid).updateData([
//            "phone_number" : phoneNumber
//        ])
//    }
    
    
}

