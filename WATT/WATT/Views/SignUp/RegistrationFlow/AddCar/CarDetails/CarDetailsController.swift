//
//  CarDetailsController.swift
//  WATT
//
//  Created by Glib Galchenko on 22/04/24.
//

import UIKit
import Combine

class CarDetailsController: BaseViewController, UITextFieldDelegate {
    var cancellables = Set<AnyCancellable>()
    
    let contentView = CarDetailsView()
    private var viewModel: CarsViewModel
    
    var selectedAddedCarID: Int = 0
    
    let deleteAction: (() -> Void)?
    
    init(viewModel: CarsViewModel, deleteAction: (() -> Void)?) {
        self.viewModel = viewModel
        self.deleteAction = deleteAction
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(contentView)
        contentView.fillSuperview()
        
        setupData()
        
        setupTargets()
    }
    
    private func setupData() {
        
        //Top Section
        contentView.topSection.logoView.loadFrom(URLAddress: viewModel.cars[selectedAddedCarID].brandThumbnailLogoURL ?? "")
        contentView.topSection.brandNameLabel.text = viewModel.cars[selectedAddedCarID].brandName
        contentView.topSection.modelLabel.text = viewModel.cars[selectedAddedCarID].carModel
        contentView.topSection.versionLabel.text = viewModel.cars[selectedAddedCarID].carVersion
        contentView.topSection.idLabel.text = viewModel.cars[selectedAddedCarID].id
        
        //General Section
        contentView.realRangeRow.detailsLabel.text = viewModel.cars[selectedAddedCarID].worstRange
        contentView.fullBatteryRow.detailsLabel.text = viewModel.cars[selectedAddedCarID].fullBattery
        contentView.usableBatteryRow.detailsLabel.text = viewModel.cars[selectedAddedCarID].usableBattery
        contentView.plugTypeRow.detailsLabel.text = viewModel.cars[selectedAddedCarID].plugType
        
        //Range Section
        contentView.cityRange.secondLabel.text = viewModel.cars[selectedAddedCarID].bestRangeCity
        contentView.cityRange.thirdLabel.text = viewModel.cars[selectedAddedCarID].worstRangeCity
        contentView.highwayRange.secondLabel.text = viewModel.cars[selectedAddedCarID].bestRangeHighway
        contentView.highwayRange.thirdLabel.text = viewModel.cars[selectedAddedCarID].worstRangeHighway
        contentView.combinedRange.secondLabel.text = viewModel.cars[selectedAddedCarID].bestRangeCombined
        contentView.combinedRange.thirdLabel.text = viewModel.cars[selectedAddedCarID].worstRangeCombined
        
        //Performance Section
        contentView.accelerationRow.detailsLabel.text = viewModel.cars[selectedAddedCarID].acceleration
        contentView.topSpeedRow.detailsLabel.text = viewModel.cars[selectedAddedCarID].topSpeed
    }
    
    private func setupTargets() {
        
        contentView.backButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
        contentView.deleteCarButton.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
    }
    
    @objc private func handleBackTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func saveButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func deleteButtonPressed() {
        deleteAction?()
        self.navigationController?.popViewController(animated: true)
    }
    
}

