//
//  EditCreditCardController.swift
//  WATT
//
//  Created by Glib Galchenko on 05/03/24.
//

import UIKit
import Combine

class EditCreditCardController: UIViewController {
    var cancellables = Set<AnyCancellable>()
    
    let contentView = EditCreditCardView()
    let paymentMethodContentView = PaymentMethodView()
    private var viewModel: PaymentMethodViewModel
    
    let action: (() -> Void)?
    
    init(viewModel: PaymentMethodViewModel, action: (() -> Void)?) {
        self.viewModel = viewModel
        self.action = action
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
        bindCvvFieldPublisher()
    }
    
    private func setupTargets() {
        contentView.backButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
        contentView.saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        contentView.toggle.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
    }
    
    @objc private func handleBackTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func saveButtonPressed() {
        let cardProvider = viewModel.checkBankProvider(number: contentView.cardNumberTextField.text ?? "")
        
        viewModel.savePaymentMethod(provider: cardProvider)
        action?()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func switchValueDidChange() {
        if contentView.toggle.isOn == true {
            self.viewModel.defaultPaymentMethod = contentView.toggle.isOn
            print("1 \(viewModel.defaultPaymentMethod)")
        } else {
            self.viewModel.defaultPaymentMethod = contentView.toggle.isOn
            print("2 \(viewModel.defaultPaymentMethod)")
        }
    }
    
    private func bindViewsToViewModel() {
        contentView.cardNameTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.cardName, on: viewModel)
            .store(in: &cancellables)
        
        contentView.cardNumberTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.cardNumber, on: viewModel)
            .store(in: &cancellables)
        
        contentView.expiryTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.expiry, on: viewModel)
            .store(in: &cancellables)
        
        contentView.cvvTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.cvv, on: viewModel)
            .store(in: &cancellables)
        
        contentView.toggle.toggleStatePublisher?
            .receive(on: DispatchQueue.main)
            .assign(to: \.defaultPaymentMethod, on: viewModel)
            .store(in: &cancellables)
        
        viewModel.isCardValid
            .sink { [weak self] isValid in
                guard let self = self else { return }
                if isValid {
                    self.contentView.saveButton.isEnabled = true
                } else {
                    self.contentView.saveButton.isEnabled = false
//                    self.contentView.saveButton.
                }
            }
            .store(in: &cancellables)
    }
    
    private func bindCvvFieldPublisher() {
        contentView.cvvTextFieldView.secureFieldPublisher = viewModel.cvvPublisher
        contentView.cvvTextFieldView.action = { self.viewModel.showCvv.toggle() }
    }
    
}
