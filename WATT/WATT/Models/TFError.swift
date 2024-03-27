//
//  TFError.swift
//  WATT
//
//  Created by Stas Boiko on 20.03.2024.
//

import Foundation

enum TFError: Error {
    case invalidEmailFormat
    case invalidPasswordLength
    case invalidRetypedPassword
    
    var description: String {
        switch self {
        case .invalidEmailFormat:
            "Invalid email format"
        case .invalidPasswordLength:
            "Password should contain at least 6 characters"
        case .invalidRetypedPassword:
            "Password don't match"
        }
    }
}
