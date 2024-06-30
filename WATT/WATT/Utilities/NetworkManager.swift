//
//  NetworkManager.swift
//  WATT
//
//  Created by Glib Galchenko on 17/04/24.
//

import Foundation
import Apollo
import ApolloAPI
import ChargeTripAPI

class NetworkManager {
    
//    static let shared = Network()
//    
//    private init() {}
    
    let store = ApolloStore()
    private(set) lazy var apollo: ApolloClient = {
        let networkTransport = RequestChainNetworkTransport(
            interceptorProvider: NetworkInterceptorProvider(store: store),
            endpointURL: URL(string: "https://api.chargetrip.io/graphql")!
        )
        return ApolloClient(networkTransport: networkTransport, store: store)
    }()
    
    @Published var allCarBrands: [CarBrand] = []
    @Published var allCarModels: [CarModel] = []
    
    @Published var selectedCar = Car()
    
    
    func removeBrandDuplicates(brands: [BrandListAllQuery.Data.CarList]) -> [CarBrand] {
        
        var sortedBrands: [CarBrand] = []
        
        var checkBrand: String?
        
        for brand in brands {
            if checkBrand != brand.naming?.make {
                sortedBrands.append(CarBrand(id: brand.id, brandName: brand.naming?.make, modelName: brand.naming?.model, brandThumbnailLogoURL: brand.media?.brand?.thumbnail_url))
                checkBrand = brand.naming?.make
            }
        }
        
        return sortedBrands
    }
    
    func loadCarBrands(completion: @escaping () -> Void) { //(completion: @escaping () -> Void)
        apollo.fetch(query: BrandListAllQuery()) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let graphQLResult):
                let brands = graphQLResult.data?.carList as! [BrandListAllQuery.Data.CarList]
                
                self.allCarBrands = removeBrandDuplicates(brands: brands)
                completion()
                
                if let errors = graphQLResult.errors {
                    print(errors)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func removeModelDuplicates(models: [ModelListAllQuery.Data.CarList]) -> [CarModel] {
        
        var sortedModels: [CarModel] = []
        
        var checkModel: String?
        
        for model in models {
            if checkModel != model.naming?.model {
                sortedModels.append(CarModel(id: model.id, carModel: model.naming?.model, carVersion: model.naming?.version, brandLogoURL: model.media?.brand?.url))
                checkModel = model.naming?.model
            }
        }
        
        return sortedModels
    }
    
    func loadCarModels(brandName: String, completion: @escaping () -> Void) {
        apollo.fetch(query: ModelListAllQuery(brandName: brandName)) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let graphQLResult):
                let models = graphQLResult.data?.carList as! [ModelListAllQuery.Data.CarList]
                
                self.allCarModels = removeModelDuplicates(models: models)
                completion()
                
                if let errors = graphQLResult.errors {
                    print(errors)
                }
               
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func loadCarDetails(carModelID: String, completion: @escaping () -> Void) { //(completion: @escaping () -> Void)
        apollo.fetch(query: CarDetailsQuery(vehicleId: carModelID)) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let graphQLResult):
                let car = graphQLResult.data?.vehicle as? CarDetailsQuery.Data.Vehicle

                self.selectedCar = Car(id: car?.id, brandName: car?.naming.make, brandThumbnailLogoURL: car?.media.make.url, carModel: car?.naming.model, carVersion: car?.naming.version, carImage: car!.media.image.url, fullBattery: car?.battery.full_kwh.description, usableBattery: car?.battery.usable_kwh.description, plugType: car?.connectors.first?.standard.value?.rawValue, seats: car?.body.seats.description, weight: car!.body.weight.nominal?.description, width: car?.body.width.description, height: car?.body.height.description, bestRange: car?.range.chargetrip_range.best?.description, worstRange: car?.range.chargetrip_range.worst?.description, acceleration: car?.performance?.acceleration?.description, topSpeed: car?.performance?.top_speed?.description, worstRangeCity: car?.range.worst.city.description, worstRangeHighway: car?.range.worst.highway.description, worstRangeCombined: car?.range.worst.combined.description, bestRangeCity: car?.range.best.city.description, bestRangeHighway: car?.range.best.highway.description, bestRangeCombined: car?.range.best.combined.description)

                completion()
                
                if let errors = graphQLResult.errors {
                    print(errors)
                }
               
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
