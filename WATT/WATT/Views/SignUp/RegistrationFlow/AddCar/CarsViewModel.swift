//
//  CarsViewModel.swift
//  WATT
//
//  Created by Glib Galchenko on 17/04/24.
//

import UIKit
import Foundation
import Combine
import Swinject
//import Apollo
import ApolloAPI
import ChargeTripAPI

class CarsViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    @Published var brandName: String = ""
    @Published var brandLogoUrl: String = ""
    
    @Published var allCarBrands: [Car] = []
    @Published var allCarModels: [CarModel] = []
    
    @Published var carBrands: [BrandListAllQuery.Data.CarList] = []
    @Published var carModels: [ModelListAllQuery.Data.CarList] = []
    
    @Published var selectedBrandName: String = ""
    @Published var selectedModelName: String = ""
    
    @Published var chosenCar = Car(id: "")
    
//    struct CarsFake {
//        let title: String
//        let image: UIImageView
//    }
//    
//    @Published var fakeDataCollection = [
//        CarsFake(title: "Audi", image: UIImageView(image: UIImage(systemName: "car"))),
//        CarsFake(title: "BMW", image: UIImageView(image: UIImage(systemName: "car.fill"))),
//        CarsFake(title: "Tesla", image: UIImageView(image: UIImage(systemName: "bolt.car")))
//    ]

//    @Published var fakeDataTable = [
//        "Audi X8",
//        "BMW M9",
//        "Tesla Sport Shos..."
//    ]
    
    init(dependencies: Resolver) {
    
    }
    
    func removeBrandDuplicates(brands: [BrandListAllQuery.Data.CarList]) -> [Car] {
        
        var duplicates: [Car] = []
        
        var prevBrand: String?
        var addedBrand: String?
        
        for brand in brands {
            if addedBrand != brand.naming?.make {
                duplicates.append(Car(id: brand.id ?? "", brandName: brand.naming?.make, brandLogoURL: brand.media?.brand?.url))
                addedBrand = brand.naming?.make
                print(addedBrand ?? "Nothing 1st")
            } else {
                prevBrand = brand.naming?.make
                print(prevBrand ?? "Nothing 2nd")
            }
            
        }
        
        return duplicates
    }
    
    func loadCarBrands(completion: @escaping () -> Void) { //(completion: @escaping () -> Void)
        Network.shared.apollo.fetch(query: BrandListAllQuery()) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let graphQLResult):
                self.carBrands = graphQLResult.data?.carList as! [BrandListAllQuery.Data.CarList]
                
                self.allCarBrands = removeBrandDuplicates(brands: self.carBrands)
                completion()
                
                if let errors = graphQLResult.errors {
                    print(errors)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
//    func loadCarBrands(completion: @escaping () -> Void) { //(completion: @escaping () -> Void)
//        Network.shared.apollo.fetch(query: BrandListAllQuery()) { [weak self] result in
//            guard let self = self else { return }
//
//            switch result {
//            case .success(let graphQLResult):
//                if let brandCarsConnection = graphQLResult.data?.carList {
//                    self.carBrands.removeAll()
//                    self.carBrands.append(contentsOf: brandCarsConnection.compactMap( { $0 } ))
//                }
//
//                if let errors = graphQLResult.errors {
//                    print(errors)
//                }
//
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
    
//    func brandName(of car: BrandListAllQuery.Data.CarList) -> String {
//        var brandName = ""
//        
//        if let name = car.naming?.make {
//            brandName.append(name)
//        }
//        
//        return brandName
//    }
    
//    func brandLogoURL(of car: BrandListAllQuery.Data.CarList) -> String {
//        var brandLogo = ""
//
//        if let logo = car.media?.brand?.url {
//            brandLogo.append(logo)
//        }
//
//        return brandLogo
//    }
    
//    func brandLogoThumbnailURL(of car: BrandListAllQuery.Data.CarList) -> String {
//        var brandLogoThumbnail = ""
//        
//        if let thumbnail = car.media?.brand?.url {
//            brandLogoThumbnail.append(thumbnail)
//        }
//        
//        return brandLogoThumbnail
//    }

//    func convertToCarModel() {
//
//        loadCarBrands()
//
//        for index in 0..<carBrands.count {
//            if !carBrands.isEmpty {
//                allCarBrands.append(
//                    Car(id: carBrands[index].id ?? "", brandName: brandName(of: carBrands[index]), brandLogoURL: brandLogoURL(of: carBrands[index]))
//                )
//            }
//        }
//    }
    
    func removeModelDuplicates(models: [ModelListAllQuery.Data.CarList]) -> [CarModel] {
        
        var duplicates: [CarModel] = []
        
        var prevModel: String?
        var addedModel: String?
        
        for model in models {
            if addedModel != model.naming?.model {
                duplicates.append(CarModel(carModel: model.naming?.model, carVersion: model.naming?.version, carImage: model.media?.image?.url))
                addedModel = model.naming?.model
                print(addedModel ?? "Nothing 1st")
            } else {
                prevModel = model.naming?.model
                print(prevModel ?? "Nothing 2nd")
            }
            
        }
        
        return duplicates
    }
    
    func loadCarModels(completion: @escaping () -> Void) {
        Network.shared.apollo.fetch(query: ModelListAllQuery(brandName: selectedBrandName)) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let graphQLResult):
                self.carModels = graphQLResult.data?.carList as! [ModelListAllQuery.Data.CarList]
                
                self.allCarModels = removeModelDuplicates(models: self.carModels)
                completion()
//                if let modelCarsConnection = graphQLResult.data?.carList {
//                    self.carModels.append(contentsOf: modelCarsConnection.compactMap( { $0 } ))
//                }
                
                if let errors = graphQLResult.errors {
                    print(errors)
                }
               
            case .failure(let error):
                print(error)
            }
        }
    }
    
//    func modelAndVersion(of car: ModelListAllQuery.Data.CarList) -> (String, String) {
//        var modelName = ""
//        var versionName = ""
//        
//        if let model = car.naming?.model {
//            modelName.append(model)
//        }
//        
//        if let version = car.naming?.version {
//            versionName.append(version)
//        }
//        
//        return (modelName, versionName)
//    }
//    
//    func carImage(of car: ModelListAllQuery.Data.CarList) -> (String, String) {
//        var carLogo = ""
//        var carLogoThumbnail = ""
//        
//        if let logo = car.media?.image?.url {
//            carLogo.append(logo)
//        }
//        
//        if let thumbnail = car.media?.image?.thumbnail_url {
//            carLogoThumbnail.append(thumbnail)
//        }
//        
//        return (carLogo, carLogoThumbnail)
//    }
    
}
