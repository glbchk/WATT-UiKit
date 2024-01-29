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
//    private let loginRepo: LoginRepository
    
    @Published var user: AppUser?
    
    init(dependencies: Resolver) {
        authenticationRepo = dependencies.resolve(AuthenticationRepository.self)!
    }
    
    
}
