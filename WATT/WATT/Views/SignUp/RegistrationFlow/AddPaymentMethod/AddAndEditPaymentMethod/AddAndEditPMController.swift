//
//  AddCreditCardController.swift
//  WATT
//
//  Created by Glib Galchenko on 01/03/24.
//

import UIKit
import Combine
import MonthYearWheelPicker

class AddAndEditPMController: BaseViewController, UITextFieldDelegate {
    var cancellables = Set<AnyCancellable>()
    
    let contentView = AddAndEditPMView()
    let paymentMethodContentView = PaymentMethodView()
    private var viewModel: PaymentMethodViewModel
    
    let toggleAction: (() -> Void)?
    let saveAction: (() -> Void)?
    let deleteAction: (() -> Void)?
    
    var isCardDetailsEmpty = false
    
    init(viewModel: PaymentMethodViewModel, toggleAction: (() -> Void)?, saveAction: (() -> Void)?, deleteAction: (() -> Void)? = nil) {
        self.viewModel = viewModel
        self.toggleAction = toggleAction
        self.saveAction = saveAction
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
        handleKeybaordAppearance()
        
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
        addButtonOnNumberPad(contentView.cardNumberTextField, target: self, selector: #selector(cardNumberTextFieldDidChange))
        contentView.expiryTextField.addTarget(self, action: #selector(expiryTextFieldDidEndEditing), for: .editingDidEnd)
        setInputViewDatePicker(contentView.expiryTextField, target: self, selector: #selector(expiryTextFieldDateChange))
        contentView.cvvTextField.addTarget(self, action: #selector(cvvTextFieldEditingChange), for: .editingChanged)
        addButtonOnNumberPad(contentView.cvvTextField, target: self, selector: #selector(cvvTextFieldEditingChange))
        
        contentView.toggle.addTarget(self, action: #selector(toggleValueDidChange), for: .valueChanged)
        
        contentView.backButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
        contentView.saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        contentView.deleteButton.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
    }
    
    private func handleKeybaordAppearance() {
        handleKeyboardAppearanceAction = { [weak self] keyboardAppeared, keyboardHeight in
            guard let self = self else { return }
            if keyboardAppeared {
                contentView.mainStack?.spacing = 10
            } else {
                contentView.mainStack?.spacing = 20
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == contentView.cardNameTextField {
            if contentView.cardNumberTextField.isEnabled && contentView.expiryTextField.isEnabled {
                contentView.cardNumberTextField.becomeFirstResponder()
            } else {
                contentView.cvvTextField.becomeFirstResponder()
            }
        }
        
        return true
    }
    
    @objc func cardNumberTextFieldDidChange() {
        contentView.cardNumberTextField.text = viewModel.formatTextWithSpaces(text: contentView.cardNumberTextField.text ?? "")
        
        if let text = contentView.cardNumberTextField.text, text.count > 19 {
            contentView.cardNumberTextField.text = String(text.prefix(19))
        }
    }
    
    @objc func expiryTextFieldDidEndEditing(_ textField: UITextField) {
        
        if contentView.expiryTextField.text?.count == 0 {
            contentView.expiryDateNotificationLabel.isHidden = false
        } else {
            contentView.expiryDateNotificationLabel.isHidden = true
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
        self.contentView.cvvTextField.becomeFirstResponder()
    }
    
    @objc func cvvTextFieldEditingChange() {
        if let text = contentView.cvvTextField.text, text.count > 3 {
            contentView.cvvTextField.text = String(text.prefix(3))
        }
    }
    
    @objc private func handleBackTap() {
        
        viewModel.cardName = ""
        viewModel.cardNumber = ""
        viewModel.expiry = ""
        viewModel.cvv = ""
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func toggleValueDidChange() {
        viewModel.defaultPaymentMethod = isToggleStateOn(isDefault: contentView.toggle.isOn)
        toggleAction?()
        print("\(viewModel.defaultPaymentMethod)")
    }
    
    @objc private func saveButtonPressed() {
        
        if !self.isCardDetailsEmpty {
            if self.contentView.cardValidityNotificationLabel.isHidden == false {
                print("Fields are empty")
                bounceCardDuplicateNotificationLabel()
                self.contentView.cvvTextField.resignFirstResponder()
            }
            
            if self.contentView.cardNameTextField.text == "" && self.contentView.cardNumberTextField.text == "" && self.contentView.expiryTextField.text == "" && self.contentView.cvvTextField.text == "" {
                print("No data")
                self.contentView.cardNameNotificationLabel.isHidden = false
                self.contentView.cardNameNotificationLabel.text = TFError.PaymentMethod.invalidCardNameLength.description
                self.contentView.cardNumberNotificationLabel.isHidden = false
                self.contentView.cardNumberNotificationLabel.text = TFError.PaymentMethod.invalidCardNumberLength.description
                self.contentView.expiryDateNotificationLabel.isHidden = false
                self.contentView.expiryDateNotificationLabel.text = TFError.PaymentMethod.invalidExpiryDate.description
                self.contentView.cvvNotificationLabel.isHidden = false
                self.contentView.cvvNotificationLabel.text = TFError.PaymentMethod.invalidCvvLength.description
            } else if self.contentView.cardNameTextField.text == "" {
                self.contentView.cardNameNotificationLabel.isHidden = false
                self.contentView.cardNameNotificationLabel.text = TFError.PaymentMethod.invalidCardNameLength.description
            } else if self.contentView.cardNumberTextField.text == "" {
                self.contentView.cardNumberNotificationLabel.isHidden = false
                self.contentView.cardNumberNotificationLabel.text = TFError.PaymentMethod.invalidCardNumberLength.description
            } else if self.contentView.expiryTextField.text == "" {
                self.contentView.expiryDateNotificationLabel.isHidden = false
                self.contentView.expiryDateNotificationLabel.text = TFError.PaymentMethod.invalidExpiryDate.description
            } else if self.contentView.cvvTextField.text == "" {
                self.contentView.cvvNotificationLabel.isHidden = false
                self.contentView.cvvNotificationLabel.text = TFError.PaymentMethod.invalidCvvLength.description
            }
        } else {
            print("Success")
            self.saveAction?()
            self.contentView.toggle.isOn = false
            
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    @objc private func deleteButtonPressed() {
        deleteAction?()
        self.navigationController?.popViewController(animated: true)
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
                
                switch isValid {
                case .success:
                    contentView.cardNameNotificationLabel.isHidden = true
                case .failure(let failure):
                    contentView.cardNameNotificationLabel.isHidden = false
                    contentView.cardNameNotificationLabel.text = failure.description
                }
            }
            .store(in: &cancellables)
        
        viewModel.cvvPublisher
            .sink { [weak self] isValid in
                guard let self = self else { return }
                let contentView = self.contentView
                
                switch isValid {
                case .success:
                    contentView.cvvNotificationLabel.isHidden = true
                case .failure(let failure):
                    contentView.cvvNotificationLabel.isHidden = false
                    contentView.cvvNotificationLabel.text = failure.description
                }
            }
            .store(in: &cancellables)
        
        if contentView.cardNumberTextField.isEnabled && contentView.expiryTextField.isEnabled {
            
            viewModel.cardNumberPublisher
                .sink { [weak self] isValid in
                    guard let self = self else { return }
                    let contentView = self.contentView
                    
                    switch isValid {
                    case .success:
                        contentView.cardNumberNotificationLabel.isHidden = true
                    case .failure(let failure):
                        contentView.cardNumberNotificationLabel.isHidden = false
                        contentView.cardNumberNotificationLabel.text = failure.description
                    }
                }
                .store(in: &cancellables)
            
            viewModel.expiryPublisher
                .sink { [weak self] isValid in
                    guard let self = self else { return }
                    let contentView = self.contentView
                    
                    switch isValid {
                    case .success:
                        contentView.expiryDateNotificationLabel.isHidden = true
                    case .failure:
                        if contentView.expiryTextField.text != "" {
                            contentView.expiryDateNotificationLabel.isHidden = false
                        }
                    }
                }
                .store(in: &cancellables)
            
            viewModel.isCardValidPublisher
                .sink { [weak self] isCardValid in
                    guard let self = self else { return }
                    
                    if isCardValid {
                        self.isCardDetailsEmpty = true
                    } else {
                        self.isCardDetailsEmpty = false
                    }
                }
                .store(in: &cancellables)
            
            viewModel.isCardDuplicatePublisher
                .sink { [weak self] isCardDublicate in
                    guard let self = self else { return }
                    let contentView = self.contentView
                    
                    switch isCardDublicate {
                    case .success:
                        contentView.cardValidityNotificationLabel.isHidden = true
                    case .failure:
                        if contentView.cardNumberTextField.text != "" {
                            contentView.cardValidityNotificationLabel.isHidden = false
                        }
                    }
                }
                .store(in: &cancellables)
        } else {
            viewModel.isEditCardValidPublisher
                .sink { [weak self] isValid in
                    guard let self = self else { return }
                    
                    if isValid {
                        self.isCardDetailsEmpty = true
                    } else {
                        self.isCardDetailsEmpty = false
                    }
                }
                .store(in: &cancellables)
        }
        
    }
    
    private func bindCvvFieldPublisher() {
        contentView.cvvTextFieldView.secureFieldPublisher = viewModel.cvvTogglePublisher
        contentView.cvvTextFieldView.action = { self.viewModel.showCvv.toggle() }
    }
    
}


extension AddAndEditPMController {
    
    private func isToggleStateOn(isDefault: Bool) -> Bool {
        var result = false
        
        if isDefault == true {
            result = isDefault
        } else {
            result = isDefault
        }
        
        return result
    }
    
    private func bounceCardDuplicateNotificationLabel() {
        
        let initialY = contentView.cardValidityNotificationLabel.frame.origin.y
        let finalY = initialY + 12
        
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
            self.contentView.cardValidityNotificationLabel.frame.origin.y = finalY
        }) { _ in
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
                self.contentView.cardValidityNotificationLabel.frame.origin.y = initialY
            })
        }
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
    
    func addButtonOnNumberPad(_ textField: UITextField, target: Any, selector: Selector) {
        
        let screenWidth = UIScreen.main.bounds.width
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        if textField == self.contentView.cardNumberTextField {
            let next = UIBarButtonItem(title: "Next", style: .plain, target: nil, action: #selector(tapCardNumberButtonNext))
            toolBar.setItems([flexible, next], animated: false)
            textField.inputAccessoryView = toolBar
        }
        
        if textField == self.contentView.cvvTextField {
            let done = UIBarButtonItem(title: "Save", style: .plain, target: nil, action: #selector(saveButtonPressed))
            toolBar.setItems([flexible, done], animated: false)
            textField.inputAccessoryView = toolBar
        }
    }
    
    @objc func tapCardNumberButtonNext() {
        
        contentView.cardNumberTextField.resignFirstResponder()
        contentView.expiryTextField.becomeFirstResponder()
    }
    
    func setInputViewDatePicker(_ textField: UITextField, target: Any, selector: Selector) {
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = MonthYearWheelPicker()
        datePicker.frame = CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 291.0)
        datePicker.backgroundColor = .white
        datePicker.onDateSelected = { (month, year) in
            _ = String(format: "%02d/%d", month, year)
        }
        
        textField.inputView = datePicker
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel))
        let barButton = UIBarButtonItem(title: "Next", style: .plain, target: target, action: selector)
        toolBar.setItems([cancel, flexible, barButton], animated: false)
        textField.inputAccessoryView = toolBar
    }
    
    @objc func tapCancel() {
        self.contentView.expiryTextField.text = nil
        
        self.contentView.expiryTextField.resignFirstResponder()
    }
    
}



