//
//  AuthenticationRepository.swift
//  WATT
//
//  Created by Glib Galchenko on 10/01/24.
//

import Combine
import Swinject
import FirebaseAuth

protocol AuthenticationRepository {
    var isAuthenticated: AnyPublisher<Bool, Never> { get }
    func sucess()
    func logOut()
}

final class AuthenticationRepositoryImpl: AuthenticationRepository {
    var isAuthenticated: AnyPublisher<Bool, Never> {
        $authenticatedPublisher.eraseToAnyPublisher()
    }
    
    @Published private var authenticatedPublisher = Auth.auth().currentUser != nil
    
    init(dependencies: Resolver) { }
    
    func sucess() {
        authenticatedPublisher = true
    }
    
    func logOut() {
        authenticatedPublisher = false
    }
    
    
}
