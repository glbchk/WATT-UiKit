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
        
        return container
    }
    
    func createAppDependencies(with authDependencies: Resolver) -> Container {
        let container = Container()
        
        return container
    }
    
}
