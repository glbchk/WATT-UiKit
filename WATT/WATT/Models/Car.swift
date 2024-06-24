//
//  Car.swift
//  WATT
//
//  Created by Glib Galchenko on 03/03/24.
//

import Foundation

struct CarBrand: Codable {
    var id: String?
    var brandName: String?
    var brandThumbnailLogoURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case brandName = "brand_name"
        case brandThumbnailLogoURL = "brand_thumbnail_logo_url"
    }
}

struct CarModel: Codable {
    var id: String?
    var carModel: String?
    var carVersion: String?
    var brandLogoURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case carModel = "car_model"
        case carVersion = "car_version"
        case brandLogoURL = "brand_logo_url"
    }
}

struct Car: Codable {
    var id: String?
    var brandName: String?
    var brandThumbnailLogoURL: String?
    var carModel: String?
    var carVersion: String?
    var carImage: String?
    var fullBattery: String?
    var usableBattery: String?
    var plugType: String?
    var seats: String?
    var weight: String?
    var width: String?
    var height: String?
    var bestRange: String?
    var worstRange: String?
    var acceleration: String?
    var topSpeed: String?
    var worstRangeCity: String?
    var worstRangeHighway: String?
    var worstRangeCombined: String?
    var bestRangeCity: String?
    var bestRangeHighway: String?
    var bestRangeCombined: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case brandName = "brand_name"
        case brandThumbnailLogoURL = "brand_thumbnail_logo_url"
        case carModel = "car_model"
        case carVersion = "car_version"
        case carImage = "car_image"
        case fullBattery = "full_battery"
        case usableBattery = "usable_battery"
        case plugType = "plug_type"
        case seats = "seats"
        case weight = "weight"
        case width = "width"
        case height = "height"
        case bestRange = "best_range"
        case worstRange = "worst_range"
        case acceleration = "acceleration"
        case topSpeed = "top_speed"
        case worstRangeCity = "worst_range_city"
        case worstRangeHighway = "worst_range_highway"
        case worstRangeCombined = "worst_range_combined"
        case bestRangeCity = "best_range_city"
        case bestRangeHighway = "best_range_highway"
        case bestRangeCombined = "best_range_combined"
    }
}


