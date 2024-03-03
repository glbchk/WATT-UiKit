//
//  AddCreditCardController.swift
//  WATT
//
//  Created by Glib Galchenko on 01/03/24.
//

import UIKit
import Combine

class AddCreditCardController: UIViewController {
    var cancellables = Set<AnyCancellable>()
    
    let contentView = AddCreditCardView()
    let paymentMethodContentView = PaymentMethodView()
    private var viewModel: SignUpViewModel
    
    let action: (() -> Void)?
    
    init(viewModel: SignUpViewModel, action: (() -> Void)?) {
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
    
    func resetFieldsData() {
        contentView.cardNameTextField.text?.removeAll()
        contentView.cardNumberTextField.text?.removeAll()
        contentView.expiryTextField.text?.removeAll()
        contentView.cvvTextField.text?.removeAll()
    }
    
    @objc private func saveButtonPressed() {
        let newPaymentMethod = PaymentMethod(cardName: contentView.cardNameTextField.text, cardNumber: contentView.cardNumberTextField.text, expiryDate: contentView.expiryTextField.text, cvv: contentView.cvvTextField.text)
        
        viewModel.savePaymentMethod(paymentMethod: newPaymentMethod)
        resetFieldsData()
        action?()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func completeLaterButtonPressed() {
        viewModel.successfulRegistration()
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
        
        contentView.cardNameTextField.inputText = viewModel.cardName
        contentView.cardNumberTextField.inputText = viewModel.cardNumber
        contentView.expiryTextField.inputText = viewModel.expiry
        contentView.cvvTextField.inputText = viewModel.cvv
    }
    
    private func bindCvvFieldPublisher() {
        contentView.cvvTextFieldView.secureFieldPublisher = viewModel.cvvPublisher
        contentView.cvvTextFieldView.action = { self.viewModel.showCvv.toggle() }
    }
    
}
