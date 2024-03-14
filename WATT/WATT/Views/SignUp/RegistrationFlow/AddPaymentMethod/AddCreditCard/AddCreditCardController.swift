//
//  AddCreditCardController.swift
//  WATT
//
//  Created by Glib Galchenko on 01/03/24.
//

import UIKit
import Combine
import MonthYearWheelPicker

class AddCreditCardController: UIViewController, UITextFieldDelegate {
    var cancellables = Set<AnyCancellable>()
    
    let contentView = AddCreditCardView()
    let paymentMethodContentView = PaymentMethodView()
    private var viewModel: PaymentMethodViewModel
    
    let actionCardVerification: (() -> Void)?
    let actionToggle: (() -> Void)?
    let action: (() -> Void)?
    
    init(viewModel: PaymentMethodViewModel, actionCardVerification: (() -> Void)?, actionToggle: (() -> Void)?, action: (() -> Void)?) {
        self.viewModel = viewModel
        self.actionCardVerification = actionCardVerification
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
        
        setupTextFieldDelegates()
        setupTargets()
        bindViewsToViewModel()
        bindCvvFieldPublisher()
        
    }
    
    private func setupTextFieldDelegates() {
        contentView.cvvTextField.delegate = self
        contentView.expiryTextField.delegate = self
        contentView.cardNumberTextField.delegate = self
    }
    
    private func setupTargets() {
        contentView.cvvTextField.addTarget(self, action: #selector(cvvTextFieldEditingChanged), for: .editingChanged)
        contentView.expiryTextField.setInputViewDatePicker(target: self, selector: #selector(expiryTextFieldDateChanged))
        contentView.cardNumberTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        contentView.backButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
        contentView.saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        contentView.toggle.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
    }
    
    @objc func cvvTextFieldEditingChanged() {
        if let text = contentView.cvvTextField.text, text.count > 3 {
            contentView.cvvTextField.text = String(text.prefix(3))
        }
    }
    
    @objc func expiryTextFieldDateChanged() {
        if let expiryDatePicker = self.contentView.expiryTextField.inputView as? MonthYearWheelPicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.dateFormat = "MM/yy"
            self.contentView.expiryTextField.text = dateFormatter.string(from: expiryDatePicker.date)
            viewModel.expiry = self.contentView.expiryTextField.text ?? ""
            
        }
        self.contentView.expiryTextField.resignFirstResponder()
        
//        contentView.expiryTextField.text = viewModel.formatDateWithSlash(text: contentView.expiryTextField.text ?? "")
//        if let text = contentView.expiryTextField.text, text.count > 5 {
//            contentView.expiryTextField.text = String(text.prefix(5))
//        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        contentView.cardNumberTextField.text = viewModel.formatTextWithSpaces(text: contentView.cardNumberTextField.text ?? "")
        if let text = contentView.cardNumberTextField.text, text.count > 19 {
            contentView.cardNumberTextField.text = String(text.prefix(19))
        }
        if textField == contentView.cardNumberTextField {
            actionCardVerification?()
        }
    }
    
    @objc private func handleBackTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func saveButtonPressed() {
        viewModel.cardNumber = viewModel.cardNumber.replacingOccurrences(of: " ", with: "")
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
        
        viewModel.isAddedCardValid
            .sink { [weak self] isValid in
                guard let self = self else { return }
                if isValid {
                    self.contentView.saveButton.isEnabled = true
                } else {
                    self.contentView.saveButton.isEnabled = false
                }
            }
            .store(in: &cancellables)
        
        viewModel.isCardsDuplicate
            .sink { [weak self] isCardDuplicate in
                guard let self = self else { return }
                if isCardDuplicate {
                    if contentView.cardNumberTextField.text != "" {
                        self.contentView.cardNumberNotificationLabel.text = "The card is already added, add another card!"
                        self.contentView.cardNumberNotificationLabel.textColor = Asset.Colors.red
                        self.contentView.saveButton.isEnabled = false
                    }
                } else {
                    if contentView.cardNumberTextField.text != "" {
                        self.contentView.cardNumberNotificationLabel.text = "Card is valid!"
                        self.contentView.cardNumberNotificationLabel.textColor = Asset.Colors.green
                        self.contentView.saveButton.isEnabled = true
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func bindCvvFieldPublisher() {
        contentView.cvvTextFieldView.secureFieldPublisher = viewModel.cvvPublisher
        contentView.cvvTextFieldView.action = { self.viewModel.showCvv.toggle() }
    }
    
}


extension AddCreditCardController {
    
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
        if textField == contentView.cardNumberTextField || textField == contentView.cvvTextField {
            let allowedCharacters = "1234567890"
            let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
            let typedCharacterSet = CharacterSet(charactersIn: string)
            let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
            return alphabet
        } else {
            return false
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == contentView.expiryTextField {
            self.view.endEditing(true)
            return true
        }
        return true
    }
    
}


extension UITextField {
    
    func setInputViewDatePicker(target: Any, selector: Selector) {
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = MonthYearWheelPicker()
        datePicker.frame = CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 216.0)
        datePicker.backgroundColor = .white
        datePicker.onDateSelected = { (month, year) in
            let string = String(format: "%02d/%d", month, year)
        }
        
        datePicker.sizeToFit()
        
        self.inputView = datePicker
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel))
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancel, flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
    
}


