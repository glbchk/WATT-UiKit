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

class CarsViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    private var networkManager = NetworkManager()
    
    @Published var selectedBrandName: String = ""
    @Published var selectedCarModelID: String = ""
    
    @Published var allCarBrands: [CarBrand] = []
    @Published var allCarModels: [CarModel] = []

    @Published var selectedCar = Car()
    
    @Published var cars: [Car] = []
    
    init(dependencies: Resolver) {
    
    }
    
    func loadBrands(completion: @escaping () -> Void) {
        networkManager.loadCarBrands { [weak self] in
            guard let self = self else { return }
            self.allCarBrands = networkManager.allCarBrands
            
            completion()
        }
    }
    
    func loadCarModels(completion: @escaping () -> Void) {
        networkManager.loadCarModels(brandName: selectedBrandName) { [weak self] in
            guard let self = self else { return }
            self.allCarModels = networkManager.allCarModels
            
            completion()
        }
    }
    
    func loadCarDetails(completion: @escaping () -> Void) {
        networkManager.loadCarDetails(carModelID: selectedCarModelID) { [weak self] in
            guard let self = self else { return }
            self.selectedCar = networkManager.selectedCar
            
            completion()
        }
    }
    
    func deleteCars(carID: String) {
        
        for index in 0..<cars.count {
            if !cars.isEmpty {
                if cars[index].id == carID {
                    cars.remove(at: index)
                }
            }
        }
    }
    
}
