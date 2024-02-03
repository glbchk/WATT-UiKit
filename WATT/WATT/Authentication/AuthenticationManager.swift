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
    
    func createUser(email: String, password: String) async throws -> AppUser {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AppUser(user: authDataResult.user)
    }
    
    func getAuthenticatedUser() throws -> AppUser {
        guard let user = Auth.auth().currentUser else {
            //TODO: Create errors
            throw URLError(.badServerResponse)
        }
        
        return AppUser(user: user)
    }
    
    func logIn(email: String, password: String) async throws -> AppUser? {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AppUser(user: authDataResult.user)
    }
    
    func signInWith(credential: AuthCredential) async throws -> AppUser {
        let authDataResult = try await Auth.auth().signIn(with: credential)
        return AppUser(user: authDataResult.user)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
}

