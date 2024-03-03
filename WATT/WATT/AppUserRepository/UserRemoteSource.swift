//
//  UserRemoteSource.swift
//  WATT
//
//  Created by Glib Galchenko on 29/01/24.
//

import Foundation

protocol UserRemoteSource {
    func createUserInDB(user: DBUser) async throws
    func getUserFromDB() async throws -> DBUser
    func checkIfUserExist(user: AppUser, completion: @escaping ((Bool) -> Void))
    func editUserNameInDB(name: String) async throws
    func editPhoneNumberInDB(phoneNumber: String) async throws
    func updatePaymentMethods(card: PaymentMethod, actionType: ActionType) async throws
    func updateSelectedPaymentMethods(_ paymentMethod: PaymentMethod) async throws
}

final class UserRemoteSourceImpl: UserRemoteSource {
    
    private var firebaseManager = FirebaseManager()
    
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
    
    func updatePaymentMethods(card: PaymentMethod, actionType: ActionType) async throws {
        try await firebaseManager.updatePaymentMethods(card: card, actionType: actionType)
    }
    
    func updateSelectedPaymentMethods(_ paymentMethod: PaymentMethod) async throws {
        try await firebaseManager.updateSelectedPaymentMethods(paymentMethod)
    }
    
    
}

