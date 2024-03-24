//
//  EditCreditCardController.swift
//  WATT
//
//  Created by Glib Galchenko on 05/03/24.
//

import UIKit
import Combine

class EditCreditCardController: BaseViewController, UITextFieldDelegate {
    var cancellables = Set<AnyCancellable>()
    
    let contentView = EditCreditCardView()
    let paymentMethodContentView = PaymentMethodView()
    private var viewModel: PaymentMethodViewModel
    
    let editAction: (() -> Void)?
    let toggleAction: (() -> Void)?
    let deleteAction: (() -> Void)?
    
    var isCardDetailsEntered = false
    
    init(viewModel: PaymentMethodViewModel, editAction: (() -> Void)?, toggleAction: (() -> Void)?, deleteAction: (() -> Void)?) {
        self.viewModel = viewModel
        self.editAction = editAction
        self.toggleAction = toggleAction
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
        
        setupTextFieldDelegates()
        setupTargets()
        bindViewsToViewModel()
        bindCvvFieldPublisher()
    }
    
    private func setupTextFieldDelegates() {
        contentView.cardNameTextField.delegate = self
        contentView.cvvTextField.delegate = self
    }
    
    private func setupTargets() {
        contentView.cvvTextField.addTarget(self, action: #selector(cvvTextFieldEditingChange), for: .editingChanged)
        
        contentView.toggle.addTarget(self, action: #selector(toggleValueDidChange), for: .valueChanged)
        
        contentView.backButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
        contentView.saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        contentView.deleteButton.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
    }
    
    @objc func cvvTextFieldEditingChange() {
        if let text = contentView.cvvTextField.text, text.count > 3 {
            contentView.cvvTextField.text = String(text.prefix(3))
        }
    }
    
    @objc private func handleBackTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func deleteButtonPressed() {
        deleteAction?()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func saveButtonPressed() {
        
        if !self.isCardDetailsEntered {
            self.contentView.cardNameNotificationLabel.isHidden = false
            self.contentView.cardNameTextFieldView.layer.borderColor = Asset.Colors.red.cgColor
            self.contentView.cvvNotificationLabel.isHidden = false
            self.contentView.cvvTextFieldView.layer.borderColor = Asset.Colors.red.cgColor
        } else {
            self.editAction?()
            self.contentView.toggle.isOn = false
            
            self.navigationController?.popViewController(animated: true)
        }

    }
    
    @objc private func toggleValueDidChange() {
        viewModel.defaultPaymentMethod = isToggleStateOn(isDefault: contentView.toggle.isOn)
        toggleAction?()
        print("\(viewModel.defaultPaymentMethod)")
    }
    
    private func bindViewsToViewModel() {
        contentView.cardNameTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.cardName, on: viewModel)
            .store(in: &cancellables)
        
        contentView.cvvTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.cvv, on: viewModel)
            .store(in: &cancellables)
        
        contentView.toggle.toggleStatePublisher?
            .receive(on: DispatchQueue.main)
            .assign(to: \.defaultPaymentMethod, on: viewModel)
            .store(in: &cancellables)
        
        
        viewModel.cardNamePublisher
            .sink { [weak self] isValid in
                guard let self = self else { return }
                let contentView = self.contentView
                if !isValid && contentView.cardNameTextField.text == "" {
                    contentView.cardNameNotificationLabel.isHidden = false
                    contentView.cardNameTextFieldView.layer.borderColor = Asset.Colors.red.cgColor
                } else {
                    contentView.cardNameNotificationLabel.isHidden = true
                    contentView.cardNameTextFieldView.layer.borderColor = Asset.Colors.grey3.cgColor
                }
            }
            .store(in: &cancellables)
        
        viewModel.cvvPublisher
            .sink { [weak self] isValid in
                guard let self = self else { return }
                let contentView = self.contentView
                if !isValid && contentView.cvvTextField.text == "" {
                    contentView.cvvNotificationLabel.isHidden = false
                    contentView.cvvTextFieldView.layer.borderColor = Asset.Colors.red.cgColor
                } else {
                    contentView.cvvNotificationLabel.isHidden = true
                    contentView.cvvTextFieldView.layer.borderColor = Asset.Colors.grey3.cgColor
                }
            }
            .store(in: &cancellables)
        
        viewModel.isEditCardValidPublisher
            .sink { [weak self] isValid in
                guard let self = self else { return }
                if isValid {
                    self.contentView.saveButton.isEnabled = true
                    self.isCardDetailsEntered = true
                } else {
                    self.contentView.saveButton.isEnabled = false
                    self.isCardDetailsEntered = false
                }
            }
            .store(in: &cancellables)
    }
    
    private func bindCvvFieldPublisher() {
        contentView.cvvTextFieldView.secureFieldPublisher = viewModel.cvvPublisher
        contentView.cvvTextFieldView.action = { self.viewModel.showCvv.toggle() }
    }
    
}

extension EditCreditCardController {
 
    private func isToggleStateOn(isDefault: Bool) -> Bool {
        var result = false
        
        if isDefault == true {
            result = isDefault
        } else {
            result = isDefault
        }
        
        return result
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == contentView.cvvTextField {
            let allowedCharacters = "1234567890"
            let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
            let typedCharacterSet = CharacterSet(charactersIn: string)
            let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
            return alphabet
        } else if textField == contentView.cardNameTextField {
            let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890 "
            let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
            let typedCharacterSet = CharacterSet(charactersIn: string)
            let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
            return alphabet
        } else {
            return false
        }
    }
    
}
