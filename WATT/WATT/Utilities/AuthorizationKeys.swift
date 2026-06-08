//
//  AuthorizationKeys.swift
//  WATT
//
//  Created by Glib Galchenko on 17/04/24.
//

import Foundation

struct AuthorizaionKeys {
    
    let clientID: XClientID
    let appID: XAppID
    
    init(clientID: String, appID: String) {
        self.clientID = .init(value: clientID)
        self.appID = .init(value: appID)
    }
    
    struct XClientID {
        let name: String = "x-client-id"
        let value: String
    }
    
    struct XAppID {
        let name: String = "x-app-id"
        let value: String
    }
    
}
