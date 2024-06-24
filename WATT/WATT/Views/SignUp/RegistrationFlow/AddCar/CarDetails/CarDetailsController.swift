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
        
        setupTargets()
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

