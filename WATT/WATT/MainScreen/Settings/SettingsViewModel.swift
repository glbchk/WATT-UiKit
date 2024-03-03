//
//  SettingsViewModel.swift
//  WATT
//
//  Created by Glib Galchenko on 01/03/24.
//

import UIKit
import Foundation
import Combine
import Swinject

class SettingsViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    @Published var email = ""
    @Published var fullName = ""
    @Published var phoneNumber = ""
    @Published var langauge = ""
    @Published var profilePhoto: UIImage? = nil
    
    @Published var user: DBUser?
    
    private let authenticationRepo: AuthenticationRepository
    private let loginRepo: LoginRepository
    private var userRepo: UserRepository
    
    
    init(dependencies: Resolver) {
        authenticationRepo = dependencies.resolve(AuthenticationRepository.self)!
        loginRepo = dependencies.resolve(LoginRepository.self)!
        userRepo = dependencies.resolve(UserRepository.self)!
        
        listenForUser()
    }
    
    func listenForUser() {
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
