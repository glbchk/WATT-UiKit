//
//  Car.swift
//  WATT
//
//  Created by Glib Galchenko on 03/03/24.
//

import Foundation

struct Cars: Codable {
    let cars: [Car]
}

struct Car: Codable, Identifiable {
    let id: String
    let brandLogo: String
    let model: CarModel
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case brandLogo = "brand_logo"
        case model = "model"
        case description = "description"
        
    }
}

struct CarModel: Codable {
    let id: String
    let model: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case model = "model"
    }
}
