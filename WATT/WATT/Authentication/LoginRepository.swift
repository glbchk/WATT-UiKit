//
//  LoginRepository.swift
//  WATT
//
//  Created by Glib Galchenko on 29/01/24.
//

import Foundation
import Swinject

protocol LoginRepository {
    func createUser(email: String, password: String) async throws -> AppUser?
    func getAuthenticatedUser() throws -> AppUser
    func logIn(email: String, password: String) async throws -> AppUser?
//    func signInGoogle() async throws -> AppUser
//    func linkGoogleAccount() async throws -> AppUser
    func signOut() throws
}

final class LoginRepositoryImpl: LoginRepository {
    
    private var remoteSource: LoginRemoteSource
    
    init(dependencies: Resolver) {
        remoteSource = dependencies.resolve(LoginRemoteSource.self)!
    }
    
    func createUser(email: String, password: String) async throws -> AppUser? {
        return try await remoteSource.createUser(email: email, password: password)
    }
    
    func getAuthenticatedUser() throws -> AppUser {
        try remoteSource.getAuthenticatedUser()
    }
    
    func logIn(email: String, password: String) async throws -> AppUser? {
        try await remoteSource.logIn(email: email, password: password)
    }
    
    func signOut() throws {
        try remoteSource.signOut()
    }
    
}

