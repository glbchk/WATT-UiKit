//
//  Car.swift
//  WATT
//
//  Created by Glib Galchenko on 03/03/24.
//

import Foundation
import ChargeTripAPI

struct CarBrand: Codable {
    var id: String?
    var brandName: String?
    var modelName: String?
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
    var carName: String?
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
    
    init(graphQLResult: CarDetailsQuery.Data.Vehicle) {
        let vehicle = graphQLResult
        self.id = vehicle.id
        self.carName = nil
        self.brandName = vehicle.naming.make
        self.brandThumbnailLogoURL = vehicle.media.make.url
        self.carModel = vehicle.naming.model
        self.carVersion = vehicle.naming.version
        self.carImage = vehicle.media.image.url
        self.fullBattery = vehicle.battery.full_kwh.description
        self.usableBattery = vehicle.battery.usable_kwh.description
        self.plugType = vehicle.connectors.first?.standard.value?.rawValue
        self.seats = vehicle.body.seats.description
        self.weight = vehicle.body.weight.nominal?.description
        self.width = vehicle.body.width.description
        self.height = vehicle.body.height.description
        self.bestRange = vehicle.range.chargetrip_range.best?.description
        self.worstRange = vehicle.range.chargetrip_range.worst?.description
        self.acceleration = vehicle.performance?.acceleration?.description
        self.topSpeed = vehicle.performance?.top_speed?.description
        self.worstRangeCity = vehicle.range.worst.city.description
        self.worstRangeHighway = vehicle.range.worst.highway.description
        self.worstRangeCombined = vehicle.range.worst.combined.description
        self.bestRangeCity = vehicle.range.best.city.description
        self.bestRangeHighway = vehicle.range.best.highway.description
        self.bestRangeCombined = vehicle.range.best.combined.description
    }
    
    init(id: String, carName: String, brandName: String, brandThumbnailLogoURL: String, carModel: String, carVersion: String, carImage: String, fullBattery: String, usableBattery: String, plugType: String, seats: String, weight: String, width: String, height: String, bestRange: String, worstRange: String, acceleration: String, topSpeed: String, worstRangeCity: String, worstRangeHighway: String, worstRangeCombined: String, bestRangeCity: String, bestRangeHighway: String, bestRangeCombined: String) {
        self.id = id
        self.carName = carName
        self.brandName = brandName
        self.brandThumbnailLogoURL = brandThumbnailLogoURL
        self.carModel = carModel
        self.carVersion = carVersion
        self.carImage = carImage
        self.fullBattery = fullBattery
        self.usableBattery = usableBattery
        self.plugType = plugType
        self.seats = seats
        self.weight = weight
        self.width = width
        self.height = height
        self.bestRange = bestRange
        self.worstRange = worstRange
        self.acceleration = acceleration
        self.topSpeed = topSpeed
        self.worstRangeCity = worstRangeCity
        self.worstRangeHighway = worstRangeHighway
        self.worstRangeCombined = worstRangeCombined
        self.bestRangeCity = bestRangeCity
        self.bestRangeHighway = bestRangeHighway
        self.bestRangeCombined = bestRangeCombined
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case carName = "car_name"
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


