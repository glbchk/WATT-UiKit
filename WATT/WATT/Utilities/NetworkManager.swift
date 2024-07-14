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
    
    static let shared = NetworkManager()
    
    private init() {}
    
    let store = ApolloStore()
    private(set) lazy var apollo: ApolloClient = {
        let networkTransport = RequestChainNetworkTransport(
            interceptorProvider: NetworkInterceptorProvider(store: store),
            endpointURL: URL(string: "https://api.chargetrip.io/graphql")!
        )
        return ApolloClient(networkTransport: networkTransport, store: store)
    }()
    
    func loadCarBrands(completion: @escaping ([BrandListAllQuery.Data.CarList]) -> Void) { //(completion: @escaping () -> Void)
        apollo.fetch(query: BrandListAllQuery()) { result in
            
            switch result {
            case .success(let graphQLResult):
                let brands = graphQLResult.data?.carList as! [BrandListAllQuery.Data.CarList]
                
                completion(brands)
                
                if let errors = graphQLResult.errors {
                    print(errors)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func loadCarModels(brandName: String, completion: @escaping ([ModelListAllQuery.Data.CarList]) -> Void) {
        apollo.fetch(query: ModelListAllQuery(brandName: brandName)) { result in
            
            switch result {
            case .success(let graphQLResult):
                let models = graphQLResult.data?.carList as! [ModelListAllQuery.Data.CarList]
                
                completion(models)
                
                if let errors = graphQLResult.errors {
                    print(errors)
                }
               
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func loadCarDetails(carModelID: String, completion: @escaping (Car) -> Void) { //(completion: @escaping () -> Void)
        apollo.fetch(query: CarDetailsQuery(vehicleId: carModelID)) { result in
            
            switch result {
            case .success(let graphQLResult):
                guard let car = graphQLResult.data?.vehicle else { return }
                let convertedCar = Car(graphQLResult: car)

                completion(convertedCar)
                
                if let errors = graphQLResult.errors {
                    print(errors)
                }
               
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
