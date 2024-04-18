//
//  AuthorizationInterceptor.swift
//  WATT
//
//  Created by Glib Galchenko on 17/04/24.
//

import Foundation
import Apollo
import ApolloAPI

class AuthorizationInterceptor: ApolloInterceptor {
    
    public var id: String = UUID().uuidString
    
    func interceptAsync<Operation>(
        chain: any RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, any Error>) -> Void
    ) where Operation : GraphQLOperation {
        let keys = AuthorizaionKeys(
            clientID: "65d616285d38790d8b08befa",
            appID: "65d616285d38790d8b08befc")
        
        request.addHeader(name: keys.clientID.name, value: keys.clientID.value)
        request.addHeader(name: keys.appID.name, value: keys.appID.value)
        
        chain.proceedAsync(
            request: request,
            response: response,
            interceptor: self,
            completion: completion)
    }
    
}
