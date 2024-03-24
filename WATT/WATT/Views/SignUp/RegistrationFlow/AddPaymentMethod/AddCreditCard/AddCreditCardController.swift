//
//  AddCreditCardController.swift
//  WATT
//
//  Created by Glib Galchenko on 01/03/24.
//

import UIKit
import Combine
import MonthYearWheelPicker

class AddCreditCardController: BaseViewController, UITextFieldDelegate {
    var cancellables = Set<AnyCancellable>()
    
    let contentView = AddCreditCardView()
    let paymentMethodContentView = PaymentMethodView()
    private var viewModel: PaymentMethodViewModel
    
    let toggleAction: (() -> Void)?
    let saveAction: (() -> Void)?
    
    var isCardDetailsEmpty = false
    
    init(viewModel: PaymentMethodViewModel, toggleAction: (() -> Void)?, saveAction: (() -> Void)?) {
        self.viewModel = viewModel
        self.toggleAction = toggleAction
        self.saveAction = saveAction
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
        
//        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { notification in
//            if let userInfo = notification.userInfo,
//               let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
//                let keyboardHeight = keyboardFrame.height
//                print("Keyboard height: \(keyboardHeight)")
//            }
//        }
    }
    
    private func setupTextFieldDelegates() {
        contentView.cardNameTextField.delegate = self
        contentView.cardNumberTextField.delegate = self
        contentView.expiryTextField.delegate = self
        contentView.cvvTextField.delegate = self
    }
    
    private func setupTargets() {
        contentView.cardNumberTextField.addTarget(self, action: #selector(cardNumberTextFieldDidChange), for: .editingChanged)
        contentView.expiryTextField.addTarget(self, action: #selector(expiryTextFieldDidBeginEditing), for: .editingDidBegin)
        contentView.expiryTextField.addTarget(self, action: #selector(expiryTextFieldDidEndEditing), for: .editingDidEnd)
        contentView.expiryTextField.setInputViewDatePicker(target: self, selector: #selector(expiryTextFieldDateChange))
        contentView.cvvTextField.addTarget(self, action: #selector(cvvTextFieldEditingChange), for: .editingChanged)
        
        contentView.toggle.addTarget(self, action: #selector(toggleValueDidChange), for: .valueChanged)
        
        contentView.backButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
        contentView.saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
    }
    
    @objc func cardNumberTextFieldDidChange() {
        contentView.cardNumberTextField.text = viewModel.formatTextWithSpaces(text: contentView.cardNumberTextField.text ?? "")
        
        if let text = contentView.cardNumberTextField.text, text.count > 19 {
            contentView.cardNumberTextField.text = String(text.prefix(19))
        }
    }
    
    @objc func expiryTextFieldDidBeginEditing(_ textField: UITextField) {
        
        if contentView.expiryTextField.text?.count != 0 {
            viewModel.isExpiryDateChanged = false
        } else {
            viewModel.isExpiryDateChanged = true
        }
    }
    
    @objc func expiryTextFieldDidEndEditing(_ textField: UITextField) {
        
        if contentView.expiryTextField.text?.count == 0 || viewModel.isExpiryDateChanged == false && contentView.expiryTextField.text?.count == 0 {
            contentView.expiryDateNotificationLabel.isHidden = false
            contentView.expiryTextFieldView.layer.borderColor = Asset.Colors.red.cgColor
        } else {
            contentView.expiryDateNotificationLabel.isHidden = true
            contentView.expiryTextFieldView.layer.borderColor = Asset.Colors.grey3.cgColor
        }
    }
    
    @objc func expiryTextFieldDateChange() {
        if let expiryDatePicker = self.contentView.expiryTextField.inputView as? MonthYearWheelPicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.dateFormat = "MM/yy"
            self.contentView.expiryTextField.text = dateFormatter.string(from: expiryDatePicker.date)
            viewModel.expiry = self.contentView.expiryTextField.text ?? ""
            
        }
        self.contentView.expiryTextField.resignFirstResponder()
    }
    
    @objc func cvvTextFieldEditingChange() {
        if let text = contentView.cvvTextField.text, text.count > 3 {
            contentView.cvvTextField.text = String(text.prefix(3))
        }
    }
    
    @objc private func handleBackTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func toggleValueDidChange() {
        viewModel.defaultPaymentMethod = isToggleStateOn(isDefault: contentView.toggle.isOn)
        toggleAction?()
        print("\(viewModel.defaultPaymentMethod)")
    }
    
    @objc private func saveButtonPressed() {
        
        if !self.isCardDetailsEmpty {
            self.contentView.cardNameNotificationLabel.isHidden = false
            self.contentView.cardNameTextFieldView.layer.borderColor = Asset.Colors.red.cgColor
            self.contentView.cardNumberNotificationLabel.isHidden = false
            self.contentView.cardNumberTextFieldView.layer.borderColor = Asset.Colors.red.cgColor
            self.contentView.expiryDateNotificationLabel.isHidden = false
            self.contentView.expiryTextFieldView.layer.borderColor = Asset.Colors.red.cgColor
            self.contentView.cvvNotificationLabel.isHidden = false
            self.contentView.cvvTextFieldView.layer.borderColor = Asset.Colors.red.cgColor
        } else {
            self.saveAction?()
            self.contentView.toggle.isOn = false
            
            self.navigationController?.popViewController(animated: true)
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
        
        viewModel.cardNamePublisher
            .sink { [weak self] isValid in
                guard let self = self else { return }
                let contentView = self.contentView
                if !isValid && contentView.cardNameTextField.text != "" {
                    contentView.cardNameNotificationLabel.isHidden = false
                    contentView.cardNameTextFieldView.layer.borderColor = Asset.Colors.red.cgColor
                } else {
                    contentView.cardNameNotificationLabel.isHidden = true
                    contentView.cardNameTextFieldView.layer.borderColor = Asset.Colors.grey3.cgColor
                }
            }
            .store(in: &cancellables)
        
        viewModel.cardNumberPublisher
            .sink { [weak self] isValid in
                guard let self = self else { return }
                let contentView = self.contentView
                if !isValid && contentView.cardNumberTextField.text != "" {
                    contentView.cardNumberNotificationLabel.isHidden = false
                    contentView.cardNumberTextFieldView.layer.borderColor = Asset.Colors.red.cgColor
                } else {
                    contentView.cardNumberNotificationLabel.isHidden = true
                    contentView.cardNumberTextFieldView.layer.borderColor = Asset.Colors.grey3.cgColor
                }
            }
            .store(in: &cancellables)
        
//        viewModel.expiryPublisher
//            .sink { [weak self] isValid in
//                guard let self = self else { return }
//                let contentView = self.contentView
//                if !isValid {
//                    contentView.expiryDateNotificationLabel.text = "Date is empty!"
////                    contentView.expiryDateNotificationLabel.isHidden = false
////                    contentView.expiryTextFieldView.layer.borderColor = Asset.Colors.red.cgColor
//                } else {
////                    contentView.expiryDateNotificationLabel.isHidden = true
////                    contentView.expiryTextFieldView.layer.borderColor = Asset.Colors.grey3.cgColor
//                }
//            }
//            .store(in: &cancellables)
        
        viewModel.cvvPublisher
            .sink { [weak self] isValid in
                guard let self = self else { return }
                let contentView = self.contentView
                if !isValid && contentView.cvvTextField.text != "" {
                    contentView.cvvNotificationLabel.isHidden = false
                    contentView.cvvTextFieldView.layer.borderColor = Asset.Colors.red.cgColor
                } else {
                    contentView.cvvNotificationLabel.isHidden = true
                    contentView.cvvTextFieldView.layer.borderColor = Asset.Colors.grey3.cgColor
                }
            }
            .store(in: &cancellables)
        
        viewModel.isCardDetailsEmptyPublisher
            .sink { [weak self] isCardDetailsEmpty in
                guard let self = self else { return }
                if isCardDetailsEmpty {
                    self.isCardDetailsEmpty = false
                } else {
                    self.isCardDetailsEmpty = true
                }
            }
            .store(in: &cancellables)
        
        viewModel.isCardValidPublisher
            .sink { [weak self] isCardValid in
                guard let self = self else { return }
                let contentView = self.contentView
                if isCardValid {
                    contentView.saveButton.isEnabled = true
                } else {
                    contentView.saveButton.isEnabled = false
                }
            }
            .store(in: &cancellables)
        
        viewModel.isCardDuplicatePublisher
            .sink { [weak self] isCardDublicate in
                guard let self = self else { return }
                let contentView = self.contentView
                if !isCardDublicate {
                    contentView.cardValidityNotificationLabel.isHidden = true
                } else {
                    if contentView.cardNumberTextField.text != "" {
                        contentView.cardValidityNotificationLabel.isHidden = false
                    }
                }
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
    
}


extension UITextField {
    
    func setInputViewDatePicker(target: Any, selector: Selector) {
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = MonthYearWheelPicker()
        datePicker.frame = CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 247.0)
        datePicker.backgroundColor = .white
        datePicker.onDateSelected = { (month, year) in
            _ = String(format: "%02d/%d", month, year)
        }
        
        self.inputView = datePicker
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel))
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancel, flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }
    
    @objc func tapCancel() {
        self.text = nil
        
        self.resignFirstResponder()
    }
    
}


