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
import ChargeTripAPI

class CarsViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    @Published var selectedBrandName: String = ""
    @Published var selectedCarModelID: String = ""
    
    @Published var allCarBrands: [CarBrand] = []
    @Published var allCarModels: [CarModel] = []

    var selectedCar: Car? = nil
    
    @Published var cars: [Car] = []
    
    @Published var carName = ""
    
    @Published var isCarValid = false
    
    init(dependencies: Resolver) {
    
    }
    
    func loadBrands(completion: @escaping () -> Void) {
        if allCarBrands.isEmpty {
            NetworkManager.shared.loadCarBrands { carBrands in
                
                var sortedBrands: [CarBrand] = []
                
                var checkBrand: String?
                
                //Remove dublicates
                for brand in carBrands {
                    if checkBrand != brand.naming?.make {
                        sortedBrands.append(CarBrand(id: brand.id, brandName: brand.naming?.make, modelName: brand.naming?.model, brandThumbnailLogoURL: brand.media?.brand?.thumbnail_url))
                        checkBrand = brand.naming?.make
                    }
                }
                
                self.allCarBrands = sortedBrands
                
                completion()
            }
        }
    }
    
    func loadCarModels(completion: @escaping () -> Void) {
        NetworkManager.shared.loadCarModels(brandName: selectedBrandName) { carModels in
            
            var sortedModels: [CarModel] = []
            
            var checkModel: String?
            
            //Remove dublicates
            for model in carModels {
                if checkModel != model.naming?.model {
                    sortedModels.append(CarModel(id: model.id, carModel: model.naming?.model, carVersion: model.naming?.version, brandLogoURL: model.media?.brand?.url))
                    checkModel = model.naming?.model
                }
            }
            
            self.allCarModels = sortedModels
            
            completion()
        }
    }
    
    func loadCarDetails(completion: @escaping () -> Void) {
        NetworkManager.shared.loadCarDetails(carModelID: selectedCarModelID) { car in
            
            self.selectedCar = car
            
            completion()
        }
    }
    
    func deleteCars(carID: String) {
        
        for index in 0..<cars.count {
            if !cars.isEmpty {
                if cars[index].id == carID {
                    cars.remove(at: index)
                    break
                }
            }
        }
    }
    
    func createCarPublisher() -> AnyPublisher<String, Never> {
        
        var carPublisher: AnyPublisher<String, Never> {
            $cars
                .map { allCars in
                    if !allCars.isEmpty {
                        var title = ""
                        
                        for car in allCars {
                            title.append("\(car.brandName ?? ""), ")
                        }
                        let cutComma = title.dropLast(2)

                        return "\(cutComma)"
                    } else {
                        return ""
                    }
                }
                .eraseToAnyPublisher()
        }
        
        return carPublisher
    }
    
    var isCarNameAddedPublisher: AnyPublisher<Result<Bool, TFError.AddCar>, Never> {
        $carName
            .debounce(for: .seconds(0.7), scheduler: RunLoop.main)
            .map { $0.isEmpty ? .success(false) : ($0.count < 3 ? .failure(.invalidCarNameLength) : .success(true)) }
            .eraseToAnyPublisher()
    }
    
    
}
