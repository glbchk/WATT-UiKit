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
    private var viewModel: PaymentMethodViewModel
    
    let actionToggle: (() -> Void)?
    let action: (() -> Void)?
    
    init(viewModel: PaymentMethodViewModel, actionToggle: (() -> Void)?, action: (() -> Void)?) {
        self.viewModel = viewModel
        self.actionToggle = actionToggle
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
        contentView.cvvTextField.addTarget(self, action: #selector(cvvTextFieldEditingChanged), for: .editingChanged)
        contentView.expiryTextField.addTarget(self, action: #selector(expiryDateTextFieldEditingChanged), for: .editingChanged)
        contentView.cardNumberTextField.addTarget(self, action: #selector(cardNumberTextFieldEditingChanged), for: .editingChanged)
        
        contentView.backButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
        contentView.saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        contentView.toggle.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
    }
    
    @objc func cvvTextFieldEditingChanged() {
        if let text = contentView.cvvTextField.text, text.count > 3 {
            contentView.cvvTextField.text = String(text.prefix(3))
        }
    }
    
    @objc func expiryDateTextFieldEditingChanged() {
        contentView.expiryTextField.text = viewModel.formatDateWithSlash(text: contentView.expiryTextField.text ?? "")
        if let text = contentView.expiryTextField.text, text.count > 5 {
            contentView.expiryTextField.text = String(text.prefix(5))
        }
    }
    
    @objc func cardNumberTextFieldEditingChanged() {
        contentView.cardNumberTextField.text = viewModel.formatTextWithSpaces(text: contentView.cardNumberTextField.text ?? "")
        if let text = contentView.cardNumberTextField.text, text.count > 19 {
            contentView.cardNumberTextField.text = String(text.prefix(19))
        }
    }
    
    @objc private func handleBackTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func saveButtonPressed() {
        action?()
        contentView.toggle.isOn = false
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func switchValueDidChange() {
        viewModel.defaultPaymentMethod = isToggleStateOn(isDefault: contentView.toggle.isOn)
        actionToggle?()
        print("\(viewModel.defaultPaymentMethod)")
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
                }
            }
            .store(in: &cancellables)
    }
    
    private func bindCvvFieldPublisher() {
        contentView.cvvTextFieldView.secureFieldPublisher = viewModel.cvvPublisher
        contentView.cvvTextFieldView.action = { self.viewModel.showCvv.toggle() }
    }
    
    private func isToggleStateOn(isDefault: Bool) -> Bool {
        var result = false
        
        if isDefault == true {
            result = isDefault
        } else {
            result = isDefault
        }
        
        return result
    }
    
}


