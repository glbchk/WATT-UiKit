//
//  TextFieldBackgroundView.swift
//  WATT
//
//  Created by Stas Boiko on 15.01.2024.
//

import UIKit
import Combine

//MARK: Add background to UITextField
class TextFieldBackgroundView: UIView {
    private var cancellables = Set<AnyCancellable>()
    
    var textField: UITextField? {
        didSet {
            setupTextField()
        }
    }
    var secureFieldPublisher: AnyPublisher<Bool, Never>? {
        didSet {
            bindSFButton()
        }
    }
    
    var validationPublisher: AnyPublisher<Result<Bool, TFError>, Never>? {
        didSet {
            bindValidationPublisher()
        }
    }
    
    var action: (() -> Void)?
    
    let sfButton = UIButton()
    
    init(tf: UITextField? = nil) {
        self.textField = tf
        self.secureFieldPublisher = nil
        self.action = nil
        super.init(frame: .zero)
        setupUI()
    }

    init(tf: UITextField?, withSecureFieldPublisher: AnyPublisher<Bool, Never>? = nil, withValidationPublisher: AnyPublisher<Result<Bool, TFError>, Never>? = nil, action: @escaping (() -> Void)) {
        self.textField = tf
        self.secureFieldPublisher = withSecureFieldPublisher
        self.validationPublisher = withValidationPublisher
        self.action = action
        super.init(frame: .zero)
        setupUI()
        bindSFButton()
        bindValidationPublisher()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.constrainHeight(50)
        
        self.backgroundColor = Asset.Colors.grey4
        self.layer.borderWidth = 1
        self.layer.borderColor = Asset.Colors.grey3.cgColor
        self.layer.cornerRadius = 10
        
        setupTextField()
    }
    
    private func setupTextField() {
        guard let textField = textField else { return }
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no
        
        addSubview(textField)
        
        textField.fillSuperview(padding: .init(top: 12, left: 15, bottom: 12, right: 15))
    }
    
    private func setupSecureFieldButton() {
        addSubview(sfButton)
        sfButton.anchor(top: self.topAnchor, leading: nil, trailing: self.trailingAnchor, bottom: self.bottomAnchor, padding: .allSides(10), size: .init(width: 24, height: 0))
        
        sfButton.tintColor = Asset.Colors.grey1
        
        sfButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        action?()
    }
    
    private func bindValidationPublisher() {
        guard let validationPublisher = validationPublisher else { return }
        
        validationPublisher
            .sink { result in
                switch result {
                case .success:
                    self.layer.borderColor = Asset.Colors.grey3.cgColor
                case .failure:
                    self.layer.borderColor = Asset.Colors.red.cgColor
                }
            }
            .store(in: &cancellables)
    }
    
    private func bindSFButton() {
        
        setupSecureFieldButton()
        
        guard let textField = textField, let sfPublisher = secureFieldPublisher else { return }
        sfPublisher
            .sink { showPassword in
                if showPassword {
                    self.sfButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
                    textField.isSecureTextEntry = false
                } else {
                    self.sfButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
                    textField.isSecureTextEntry = true
                }
            }
            .store(in: &cancellables)
        
    }
    
}
