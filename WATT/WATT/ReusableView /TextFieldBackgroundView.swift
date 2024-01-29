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
    
    let textField: UITextField
    let secureFieldPublisher: AnyPublisher<Bool, Never>?
    let action: (() -> Void)?
    
    let sfButton = UIButton()
    
    init(tf: UITextField) {
        self.textField = tf
        self.secureFieldPublisher = nil
        self.action = nil
        super.init(frame: .zero)
        setupUI()
    }

    init(tf: UITextField, withSecureFieldPublisher: AnyPublisher<Bool, Never>, action: @escaping (() -> Void)) {
        self.textField = tf
        self.secureFieldPublisher = withSecureFieldPublisher
        self.action = action
        super.init(frame: .zero)
        setupUI()
        setupSecureFieldButton()
        bindSFButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        addSubview(textField)
        
        self.constrainHeight(50)
//        self.constrainWidth(UIScreen.main.bounds.width - 40)
        
        textField.fillSuperview(padding: .init(top: 12, left: 15, bottom: 12, right: 15))
        
        self.backgroundColor = UIColor(red: 244/255, green: 246/255, blue: 249/255, alpha: 1)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 219/255, green: 223/255, blue: 227/255, alpha: 1).cgColor
        self.layer.cornerRadius = 10
    
    }
    
    private func setupSecureFieldButton() {
        addSubview(sfButton)
        sfButton.anchor(top: self.topAnchor, leading: nil, trailing: self.trailingAnchor, bottom: self.bottomAnchor, padding: .allSides(10), size: .init(width: 24, height: 0))
        
        sfButton.tintColor = UIColor(red: 134/255, green: 146/255, blue: 169/255, alpha: 1)
        
        sfButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        action?()
    }
    
    private func bindSFButton() {
        guard let sfPublisher = secureFieldPublisher else { return }
        sfPublisher
            .sink { showPassword in
                if showPassword {
                    self.sfButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
                    self.textField.isSecureTextEntry = false
                } else {
                    self.sfButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
                    self.textField.isSecureTextEntry = true
                }
            }
            .store(in: &cancellables)
        
    }
    
}
