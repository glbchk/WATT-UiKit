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
    private var viewModel: PaymentMethodViewModel
    
    let editAction: (() -> Void)?
    let deleteAction: (() -> Void)?
    
    var isCardDetailsEntered = false
    
    init(viewModel: PaymentMethodViewModel, editAction: (() -> Void)?, deleteAction: (() -> Void)?) {
        self.viewModel = viewModel
        self.editAction = editAction
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
    }
    
    private func setupTextFieldDelegates() {
        contentView.cardNameTextField.delegate = self
        contentView.cvvTextField.delegate = self
    }
    
    private func setupTargets() {
//        contentView.cvvTextField.addTarget(self, action: #selector(cvvTextFieldEditingChange), for: .editingChanged)
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
            contentView.cvvTextField.becomeFirstResponder()
        }
        
        return true
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
            self.contentView.cvvNotificationLabel.isHidden = false
        } else {
            self.editAction?()
            self.contentView.toggle.isOn = false
            
            self.navigationController?.popViewController(animated: true)
        }

    }
    
    @objc private func toggleValueDidChange() {
        viewModel.defaultPaymentMethod = isToggleStateOn(isDefault: contentView.toggle.isOn)

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
        
        viewModel.isEditCardValidPublisher
            .sink { [weak self] isValid in
                guard let self = self else { return }
                
                if isValid {
                    self.isCardDetailsEntered = true
                } else {
                    self.isCardDetailsEntered = false
                }
            }
            .store(in: &cancellables)
    }
    
    private func bindCvvFieldPublisher() {
        contentView.cvvTextFieldView.secureFieldPublisher = viewModel.cvvTogglePublisher
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
    
    func addButtonOnNumberPad(_ textField: UITextField, target: Any, selector: Selector) {
        
        let screenWidth = UIScreen.main.bounds.width
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        if textField == self.contentView.cvvTextField {
            let done = UIBarButtonItem(title: "Save", style: .plain, target: nil, action: #selector(saveButtonPressed))
            toolBar.setItems([flexible, done], animated: false)
            textField.inputAccessoryView = toolBar
        }
    }
    
}
