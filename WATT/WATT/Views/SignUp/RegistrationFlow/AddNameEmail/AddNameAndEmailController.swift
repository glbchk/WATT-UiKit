//
//  AddNameAndEmailController.swift
//  WATT
//
//  Created by Stas Boiko on 10.02.2024.
//

import UIKit
import Combine

class AddNameAndEmailController: UIViewController {
    
    let contentView = AddNameAndEmailView()
    private var viewModel: SignUpViewModel
    var cancellables = Set<AnyCancellable>()
    
    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
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
        bindViewsToViewModel()
    }
    
    private func setupTargets() {
        contentView.backButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
        contentView.saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
    }
    
    @objc private func handleBackTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func saveButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func bindViewsToViewModel() {
        contentView.nameTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.fullName, on: viewModel)
            .store(in: &cancellables)
        
        contentView.phoneNumberTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.phoneNumber, on: viewModel)
            .store(in: &cancellables)
    }
    
}
