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
    let brandName: String?
     let brandLogoURL: String?
//    let brandLogoThumbnailURL: String?
    let carModel: CarModel?
       
    init(
        id: String,
        brandName: String? = nil,
        brandLogoURL: String? = nil,
//        brandLogoThumbnailURL: String? = nil,
        carModel: CarModel? = nil
    ) {
        self.id = id
        self.brandName = brandName
        self.brandLogoURL = brandLogoURL
//        self.brandLogoThumbnailURL = brandLogoThumbnailURL
        self.carModel = carModel
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case brandName = "brand_name"
        case brandLogoURL = "brand_logo_url"
//        case brandLogoThumbnailURL = "brand_logo_thumbnail_url"
        case carModel = "car_model"
    }
}

struct CarModel: Codable {
    let carModel: String?
    let carVersion: String?
    let carImage: String?
//    let carThumbnailImage: String?
    
    enum CodingKeys: String, CodingKey {
        case carModel = "car_model"
        case carVersion = "car_version"
        case carImage = "car_image"
//        case carThumbnailImage = "car_thumbnail_image"
    }
}
