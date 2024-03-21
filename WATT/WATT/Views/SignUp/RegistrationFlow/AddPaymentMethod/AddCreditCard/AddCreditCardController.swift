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
        
        hideAllNotificationLabels()
    }
    
    private func setupTextFieldDelegates() {
        contentView.cardNameTextField.delegate = self
        contentView.cardNumberTextField.delegate = self
        contentView.expiryTextField.delegate = self
        contentView.cvvTextField.delegate = self
    }
    
    private func setupTargets() {
        contentView.cardNameTextField.addTarget(self, action: #selector(cardNameTextFieldDidBeginEditing), for: .editingDidBegin)
        contentView.cardNameTextField.addTarget(self, action: #selector(cardNameTextFieldDidEndEditing), for: .editingDidEnd)
        
        contentView.cardNumberTextField.addTarget(self, action: #selector(cardNumberTextFieldDidBeginEditing), for: .editingDidBegin)
        contentView.cardNumberTextField.addTarget(self, action: #selector(cardNumberTextFieldDidEndEditing), for: .editingDidEnd)
        contentView.cardNumberTextField.addTarget(self, action: #selector(cardNumberTextFieldDidChange), for: .editingChanged)
        
        contentView.expiryTextField.addTarget(self, action: #selector(expiryDateTextFieldDidBeginEditing), for: .editingDidBegin)
        contentView.expiryTextField.addTarget(self, action: #selector(expiryDateTextFieldDidEndEditing), for: .editingDidEnd)
        contentView.expiryTextField.setInputViewDatePicker(target: self, selector: #selector(expiryTextFieldDateChanged))
        
        contentView.cvvTextField.addTarget(self, action: #selector(cvvTextFieldDidBeginEditing), for: .editingDidBegin)
        contentView.cvvTextField.addTarget(self, action: #selector(cvvTextFieldDidEndEditing), for: .editingDidEnd)
        contentView.cvvTextField.addTarget(self, action: #selector(cvvTextFieldEditingChanged), for: .editingChanged)
        
        contentView.backButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
        contentView.saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        contentView.toggle.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
    }
    
    private func hideAllNotificationLabels() {
        self.contentView.cardNameNotificationLabel.isHidden = true
        self.contentView.cardNumberNotificationLabel.isHidden = true
        self.contentView.cvvNotificationLabel.isHidden = true
        self.contentView.cardValidityNotificationLabel.isHidden = true
    }
    
    @objc private func cardNameTextFieldDidBeginEditing(_ textField: UITextField) {
        if let text = contentView.cardNameTextField.text, text.count == 0 {
            self.contentView.cardNameNotificationLabel.isHidden = true
        } else {
            self.contentView.cardNameNotificationLabel.isHidden = true
            self.contentView.cardNameTextFieldView.layer.borderColor = Asset.Colors.grey3.cgColor
        }
    }
    
    @objc private func cardNameTextFieldDidEndEditing(_ textField: UITextField) {

        if let text = contentView.cardNameTextField.text, text.count <= 3 {
            self.contentView.cardNameNotificationLabel.isHidden = false
            self.contentView.cardNameTextFieldView.layer.borderColor = Asset.Colors.red.cgColor
        } else {
            self.contentView.cardNameNotificationLabel.isHidden = true
            self.contentView.cardNameTextFieldView.layer.borderColor = Asset.Colors.grey3.cgColor
        }
    }
    
    @objc private func cardNumberTextFieldDidBeginEditing(_ textField: UITextField) {
        
        if let text = contentView.cardNumberTextField.text, text.count == 0 {
            self.contentView.cardNumberNotificationLabel.isHidden = true
        } else {
            self.contentView.cardNumberNotificationLabel.isHidden = true
            self.contentView.cardNumberTextFieldView.layer.borderColor = Asset.Colors.grey3.cgColor
        }
    }
    
    @objc private func cardNumberTextFieldDidEndEditing(_ textField: UITextField) {
        
        if let text = contentView.cardNumberTextField.text, text.count <= 18 {
            self.contentView.cardNumberNotificationLabel.isHidden = false
            self.contentView.cardNumberTextFieldView.layer.borderColor = Asset.Colors.red.cgColor
        } else {
            self.contentView.cardNumberNotificationLabel.isHidden = true
            self.contentView.cardNumberTextFieldView.layer.borderColor = Asset.Colors.grey3.cgColor
        }
//        if textField == contentView.cardNumberTextField {
//            actionCardVerification?()
//        }
    }
    
    @objc private func expiryDateTextFieldDidBeginEditing(_ textField: UITextField) {
        
        if let text = contentView.expiryTextField.text, text.count == 0 {
            self.contentView.expiryDateNotificationLabel.isHidden = true
        } else {
            self.contentView.expiryDateNotificationLabel.isHidden = true
            self.contentView.expiryTextFieldView.layer.borderColor = Asset.Colors.grey3.cgColor
        }
    }
    
    @objc private func expiryDateTextFieldDidEndEditing(_ textField: UITextField) {
        
        if let text = contentView.expiryTextField.text, text.count == 0 {
            self.contentView.expiryDateNotificationLabel.isHidden = false
            self.contentView.expiryTextFieldView.layer.borderColor = Asset.Colors.red.cgColor
        } else {
            self.contentView.expiryDateNotificationLabel.isHidden = true
            self.contentView.expiryTextFieldView.layer.borderColor = Asset.Colors.grey3.cgColor
        }
    }
    
    @objc private func cvvTextFieldDidBeginEditing(_ textField: UITextField) {
        
        if let text = contentView.cvvTextField.text, text.count == 0 {
            self.contentView.cvvNotificationLabel.isHidden = true
        } else {
            self.contentView.cvvNotificationLabel.isHidden = true
            self.contentView.cvvTextFieldView.layer.borderColor = Asset.Colors.grey3.cgColor
        }
    }
    
    @objc private func cvvTextFieldDidEndEditing(_ textField: UITextField) {
        
        if let text = contentView.cvvTextField.text, text.count <= 2 {
            self.contentView.cvvNotificationLabel.isHidden = false
            self.contentView.cvvTextFieldView.layer.borderColor = Asset.Colors.red.cgColor
        } else {
            self.contentView.cvvNotificationLabel.isHidden = true
            self.contentView.cvvTextFieldView.layer.borderColor = Asset.Colors.grey3.cgColor
        }
    }
    
//    @objc func cardNameTextFieldDidChange(_ textField: UITextField) {
//        if let text = contentView.cardNameTextField.text, text.count >= 4 {
//            self.contentView.cardNameNotificationLabel.isHidden = false
//        }
////        if textField == contentView.cardNumberTextField {
////            actionCardVerification?()
////        }
//    }
    
    @objc func cardNumberTextFieldDidChange() {
        contentView.cardNumberTextField.text = viewModel.formatTextWithSpaces(text: contentView.cardNumberTextField.text ?? "")
        
        if let text = contentView.cardNumberTextField.text, text.count > 19 {
            contentView.cardNumberTextField.text = String(text.prefix(19))
        }
        
        actionCardVerification?()
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
    
    @objc func cvvTextFieldEditingChanged() {
        if let text = contentView.cvvTextField.text, text.count > 3 {
            contentView.cvvTextField.text = String(text.prefix(3))
        }
    }
    
    @objc private func handleBackTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func saveButtonPressed() {
//        viewModel.cardNumber = viewModel.cardNumber.replacingOccurrences(of: " ", with: "")

        action?()
        contentView.toggle.isOn = false
        contentView.saveButton.isEnabled = false
        contentView.saveButton.backgroundColor = Asset.Colors.grey1
        
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
        
        viewModel.cardNamePublisher
            .sink { [weak self] isValid in
                guard let self = self else { return }
                if !isValid {
                    self.contentView.cardNameNotificationLabel.text = "Card name doesn't have at least 4 symbols!"
                    self.contentView.cardNameNotificationLabel.textColor = Asset.Colors.red
                }
            }
            .store(in: &cancellables)
        
        viewModel.cardNumberPublisher
            .sink { [weak self] isValid in
                guard let self = self else { return }
                if !isValid {
                    self.contentView.cardNumberNotificationLabel.text = "Card number is not 16 digits!"
                    self.contentView.cardNumberNotificationLabel.textColor = Asset.Colors.red
                }
            }
            .store(in: &cancellables)
        
        viewModel.expiryPublisher
            .sink { [weak self] isValid in
                guard let self = self else { return }
                if !isValid {
                    self.contentView.expiryDateNotificationLabel.text = "Date is empty!"
                    self.contentView.expiryDateNotificationLabel.textColor = Asset.Colors.red
                }
            }
            .store(in: &cancellables)
        
        viewModel.cvvPublisher
            .sink { [weak self] isValid in
                guard let self = self else { return }
                if !isValid {
                    self.contentView.cvvNotificationLabel.text = "Should be 3 digits!"
                    self.contentView.cvvNotificationLabel.textColor = Asset.Colors.red
                }
            }
            .store(in: &cancellables)
        
        viewModel.isCardDetailsValid
            .sink { [weak self] isValid in
                guard let self = self else { return }
                let contentView = self.contentView
                if isValid {
                    if contentView.cardValidityNotificationLabel.isHidden == true {
                        contentView.saveButton.isEnabled = true
                        contentView.saveButton.backgroundColor = Asset.Colors.deepBlue
                    } else {
                        contentView.saveButton.isEnabled = false
                        contentView.saveButton.backgroundColor = Asset.Colors.grey1
                    }
//                    contentView.cardValidityNotificationLabel.isHidden = true
                } else {
                    contentView.saveButton.isEnabled = false
                    contentView.saveButton.backgroundColor = Asset.Colors.grey1
//                    contentView.cardValidityNotificationLabel.isHidden = false
//                    contentView.cardValidityNotificationLabel.text = "Card isn't valid!"
//                    contentView.cardValidityNotificationLabel.textColor = Asset.Colors.red
                }
            }
            .store(in: &cancellables)
        
        viewModel.isCardDupblicate
            .sink { [weak self] isCardDuplicate in
                guard let self = self else { return }
//                if viewModel.isCardNumberValid != "" {
                    if isCardDuplicate {
                        if viewModel.isCardNumberValid != "" {
                            self.contentView.saveButton.isEnabled = false
                            self.contentView.saveButton.backgroundColor = Asset.Colors.grey1
                            self.contentView.cardValidityNotificationLabel.isHidden = false
                            self.contentView.cardValidityNotificationLabel.text = "The card is already added, add another card!"
                            self.contentView.cardValidityNotificationLabel.textColor = Asset.Colors.red
                        }
                    } else {
                        self.contentView.cardValidityNotificationLabel.isHidden = true
                    }
//                }
            }
            .store(in: &cancellables)
    }
    
    private func bindCvvFieldPublisher() {
        contentView.cvvTextFieldView.secureFieldPublisher = viewModel.cvvTogglePublisher
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


