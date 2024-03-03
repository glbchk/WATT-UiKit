//
//  AuthenticationManager.swift
//  WATT
//
//  Created by Glib Galchenko on 29/01/24.
//

import Foundation
import Firebase
import FirebaseAuth

final class AuthenticationManager {
    
    let authentication: Auth
    
    init() {
        self.authentication = Auth.auth()
    }
    
    func signInAnonymously() async throws -> AppUser {
        let authResult = try await authentication.signInAnonymously()
        return AppUser(user: authResult.user)
    }
    
    func linkEmail(email: String, password: String) async throws -> AppUser {
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        guard let user = authentication.currentUser else {
            throw URLError(.badServerResponse)
        }
        
        let authResult = try await user.link(with: credential)
        return AppUser(user: authResult.user)
    }
    
    func createUser(email: String, password: String) async throws -> AppUser {
        let authDataResult = try await authentication.createUser(withEmail: email, password: password)
        return AppUser(user: authDataResult.user)
    }
    
    func getAuthenticatedUser() throws -> AppUser {
        guard let user = authentication.currentUser else {
            //TODO: Create errors
            throw URLError(.badServerResponse)
        }
        
        return AppUser(user: user)
    }
    
    func logIn(email: String, password: String) async throws -> AppUser? {
        let authDataResult = try await authentication.signIn(withEmail: email, password: password)
        return AppUser(user: authDataResult.user)
    }
    
    func sendEmailVerification(completion: @escaping ((Bool) -> Void)) async throws {
        try await authentication.currentUser?.sendEmailVerification()
    }
    
    func checkIsEmailVerified(completion: @escaping ((Bool) -> Void)) throws {
        guard let isVerified = authentication.currentUser?.isEmailVerified else {
            throw URLError(.badServerResponse)
        }
        
        if isVerified {
            print("Email is varified: \(isVerified)")
        } else {
            print("Email is not varified: \(isVerified)")
        }
    }
    
    func reloadUser(completion: @escaping ((Bool) -> Void)) async throws {
        try await authentication.currentUser?.reload()
    }
    
    func sendPasswordReset(email: String, completion: @escaping ((Bool) -> Void)) async throws {
        try await authentication.sendPasswordReset(withEmail: email)
    }
    
    func signOut() throws {
        try authentication.signOut()
    }
}

