//
//  DependencyInjection.swift
//  WATT
//
//  Created by Glib Galchenko on 10/01/24.
//

import Foundation
import Swinject


extension AppDelegate {

    func createAuthDependencies() -> Container {
        let container = Container()
        
        container.register(AuthenticationRepository.self) { resolver in
            AuthenticationRepositoryImpl(dependencies: resolver)
        }
        .inObjectScope(.container)
        
        registerUserRemoteSource(in: container)
        registerLoginModel(in: container)
        
        return container
    }
    
    func createAppDependencies(with authDependencies: Resolver) -> Container {
        let container = Container()
        
        registerAuthenticationRepository(from: authDependencies, in: container)
        registerLoginModel(in: container)
        registerUserRemoteSource(in: container)
        
        return container
    }
    
    private func registerAuthenticationRepository(from resolver: Resolver, in container: Container) {
        container
            .register(AuthenticationRepository.self) { _ in
                resolver.resolve(AuthenticationRepository.self)!
            }
            .inObjectScope(.container)
    }
    
    private func registerLoginModel(in container: Container) {
        let registeredContainer = Container()
        
        registeredContainer.register(LoginRemoteSource.self) { _ in
            LoginRemoteSourceImpl()
        }
        container.register(LoginRepository.self) { _ in
            LoginRepositoryImpl(dependencies: registeredContainer)
        }
        .inObjectScope(.container)
    }
    
    private func registerUserRemoteSource(in container: Container) {
        let registeredContainer = Container()
        
        registeredContainer.register(UserRemoteSource.self) { _ in
            UserRemoteSourceImpl()
        }
        
        container.register(UserRepository.self) { _ in
            UserRepositoryImpl(dependencies: registeredContainer)
        }
        .inObjectScope(.container)
    }
    
}
