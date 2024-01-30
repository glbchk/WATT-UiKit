//
//  UserRemoteSource.swift
//  WATT
//
//  Created by Glib Galchenko on 29/01/24.
//

import Foundation

protocol UserRemoteSource {
    func createUserInDB(user: AppUser) async throws
    func getUserFromDB() async throws -> AppUser
    func checkIfUserExist(user: AppUser, completion: @escaping ((Bool) -> Void))
}

final class UserRemoteSourceImpl: UserRemoteSource {
    
    private var firebaseManager = FirebaseManager()
    
    func createUserInDB(user: AppUser) async throws {
        try await firebaseManager.createUserInDB(user: user)
    }
    
    func getUserFromDB() async throws -> AppUser {
        return try await firebaseManager.getUserFromDB()
    }
    
    func checkIfUserExist(user: AppUser, completion: @escaping ((Bool) -> Void)) {
        firebaseManager.checkIfUserExists(user: user, completion: completion)
    }
    
    
    
    
}

