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
    var user: AnyPublisher<DBUser?, Never> { get }
    
    func createAnonymousUserInDB(user: DBUser) async throws
    func createUserInDB(user: DBUser) async throws
    func checkIfUserExist(user: AppUser, completion: @escaping ((Bool) -> Void))
    func editUserNameInDB(name: String) async throws
    func editPhoneNumberInDB(phoneNumber: String) async throws
    func updatePaymentMethods(card: PaymentMethod, actionType: ActionType) async throws
    func updateSelectedPaymentMethods(_ paymentMethod: PaymentMethod) async throws
    func updateCarInfo(_ car: Car) async throws
}

final class UserRepositoryImpl: UserRepository {
    
    @Published private var userPublisher: DBUser?
    
    var user: AnyPublisher<DBUser?, Never> {
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
    
    func createAnonymousUserInDB(user: DBUser) async throws {
        try await remoteSource.createAnonymousUserInDB(user: user)
    }
    
    func createUserInDB(user: DBUser) async throws {
        try await remoteSource.createUserInDB(user: user)
    }
    
    func checkIfUserExist(user: AppUser, completion: @escaping ((Bool) -> Void)) {
        remoteSource.checkIfUserExist(user: user, completion: completion)
    }
    
    func editUserNameInDB(name: String) async throws {
        try await remoteSource.editUserNameInDB(name: name)
        getUser()
    }
    
    func editPhoneNumberInDB(phoneNumber: String) async throws {
        try await remoteSource.editPhoneNumberInDB(phoneNumber: phoneNumber)
        getUser()
    }
    
    func updatePaymentMethods(card: PaymentMethod, actionType: ActionType) async throws {
        try await remoteSource.updatePaymentMethods(card: card, actionType: actionType)
    }
    
    func updateSelectedPaymentMethods(_ paymentMethod: PaymentMethod) async throws {
        try await remoteSource.updateSelectedPaymentMethods(paymentMethod)
    }
    
    func updateCarInfo(_ car: Car) async throws {
        try await remoteSource.updateCarInfo(car)
    }
    
}

