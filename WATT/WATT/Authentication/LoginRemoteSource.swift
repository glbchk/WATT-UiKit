//
//  LoginRemoteSource.swift
//  WATT
//
//  Created by Glib Galchenko on 29/01/24.
//

import Foundation
import Firebase

protocol LoginRemoteSource {
    func signInAnonymously() async throws -> AppUser
    func createUser(email: String, password: String) async throws -> AppUser?
    func getAuthenticatedUser() throws -> AppUser
    func logIn(email: String, password: String) async throws -> AppUser?
//    func signInGoogle() async throws -> AppUser
//    func linkGoogleAccount() async throws -> AppUser
    func signOut() throws
}

final class LoginRemoteSourceImpl: LoginRemoteSource {
    
    private var authenticationManager: AuthenticationManager {
        AuthenticationManager()
    }
    
    func signInAnonymously() async throws -> AppUser {
        let user = try await authenticationManager.signInAnonymously()
        return user
    }
    
    func createUser(email: String, password: String) async throws -> AppUser? {
        let user = try await authenticationManager.createUser(email: email, password: password)
        return user
    }
    
    func getAuthenticatedUser() throws -> AppUser {
        try authenticationManager.getAuthenticatedUser()
    }
    
    func logIn(email: String, password: String) async throws -> AppUser? {
        let user = try await authenticationManager.logIn(email: email, password: password)
        return user
    }
    
    func signOut() throws {
        try authenticationManager.signOut()
    }
    
}

