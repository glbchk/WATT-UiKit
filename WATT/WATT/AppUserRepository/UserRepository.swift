//
//  UserRepository.swift
//  WATT
//
//  Created by Glib Galchenko on 29/01/24.
//

import Foundation
import Combine
import Swinject

protocol UserRepository {
    var user: AnyPublisher<AppUser?, Never> { get }
    
    func createUserInDB(user: AppUser) async throws
    func checkIfUserExist(user: AppUser, completion: @escaping ((Bool) -> Void))
}

final class UserRepositoryImpl: UserRepository {
    
    @Published private var userPublisher: AppUser?
    
    var user: AnyPublisher<AppUser?, Never> {
        $userPublisher.eraseToAnyPublisher()
    }
    
    private let remoteSource: UserRemoteSource
    
    init(dependencies: Resolver) {
        remoteSource = dependencies.resolve(UserRemoteSource.self)!
        getUser()
    }
    
    private func getUser() {
        Task(priority: .medium) { [remoteSource, weak self] in
            let user = try await remoteSource.getUserFromDB()
            self?.userPublisher = user
        }
    }
    
    func createUserInDB(user: AppUser) async throws {
        try await remoteSource.createUserInDB(user: user)
    }
    
    func checkIfUserExist(user: AppUser, completion: @escaping ((Bool) -> Void)) {
        remoteSource.checkIfUserExist(user: user, completion: completion)
    }

    
    
}

