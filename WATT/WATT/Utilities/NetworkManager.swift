//
//  NetworkManager.swift
//  WATT
//
//  Created by Glib Galchenko on 17/04/24.
//

import Foundation
import Apollo
import ApolloAPI

class Network {
    
    static let shared = Network()
    
    private init() {}
    
    let store = ApolloStore()
    private(set) lazy var apollo: ApolloClient = {
        let networkTransport = RequestChainNetworkTransport(
            interceptorProvider: NetworkInterceptorProvider(store: store),
            endpointURL: URL(string: "https://api.chargetrip.io/graphql")!
        )
        return ApolloClient(networkTransport: networkTransport, store: store)
    }()
}
