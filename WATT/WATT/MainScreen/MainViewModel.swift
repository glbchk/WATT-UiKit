//
//  MainScreenViewModel.swift
//  WATT
//
//  Created by Glib Galchenko on 11/01/24.
//

import Foundation
import Swinject
import Combine

final class MainViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    private let authenticationRepo: AuthenticationRepository
    private let loginRepo: LoginRepository
    private let userRepo: UserRepository
    
    @Published var user: DBUser?
    
    init(dependencies: Resolver) {
        authenticationRepo = dependencies.resolve(AuthenticationRepository.self)!
        loginRepo = dependencies.resolve(LoginRepository.self)!
        userRepo = dependencies.resolve(UserRepository.self)!
        
        listenForUser()
    }
    
    private func listenForUser() {
        userRepo.user
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                self?.user = user
            }
            .store(in: &cancellables)
    }
    
    func signOut() {
        Task(priority: .medium) { [authenticationRepo, loginRepo] in
            do {
                try loginRepo.signOut()
                authenticationRepo.logOut()
            } catch {
                print("Error:", error)
            }
        }
    }
    
}
