//
//  SignUpViewGlib.swift
//  WATT
//
//  Created by Glib Galchenko on 29/01/24.
//

import UIKit

final class SignUpViewGlib: UIView {

    lazy var stackView = UIStackView()
    
    lazy var signUpTitle = UILabel()
    lazy var nameTextField = UITextField()
    lazy var emailTextField = UITextField()
    lazy var passwordTextField = UITextField()
    lazy var signUpButton = UIButton()
    lazy var errorLabel = UILabel()
    
//    lazy var activeTextField: UITextField?
    
    init() {
        super.init(frame: .zero)
        
        setupConstraints()
        addSubviews(to: stackView)
        setupUIComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews(to stackView: UIStackView) {
        [signUpTitle, nameTextField, emailTextField, passwordTextField, signUpButton, errorLabel]
            .forEach {
                stackView.addArrangedSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
                if $0 is UITextField || $0 is UIButton {
                    $0.heightAnchor.constraint(equalToConstant: 50).isActive = true
                }
            }
    }
    
    private func setupConstraints() {
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 28),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -28)
        ])
    }
    
    private func setupUIComponents() {
        backgroundColor = .white
        
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        
        signUpTitle.text = "Sign up Sign up Sign up"
        signUpTitle.lineBreakMode = .byWordWrapping
        signUpTitle.numberOfLines = 0
        signUpTitle.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        signUpTitle.textColor = .black
        
        nameTextField.placeholder = "Enter full name..."
        nameTextField.font = UIFont.systemFont(ofSize: 15)
        nameTextField.borderStyle = UITextField.BorderStyle.roundedRect
        nameTextField.autocorrectionType = UITextAutocorrectionType.no
        nameTextField.keyboardType = UIKeyboardType.default
        nameTextField.returnKeyType = UIReturnKeyType.next
        nameTextField.textColor = UIColor.black
        
        emailTextField.placeholder = "Enter email..."
        emailTextField.font = UIFont.systemFont(ofSize: 15)
        emailTextField.borderStyle = .roundedRect
        emailTextField.textContentType = .emailAddress
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocorrectionType = .no
        emailTextField.returnKeyType = .next
        emailTextField.textColor = .black
        
        passwordTextField.placeholder = "Enter password..."
        passwordTextField.font = UIFont.systemFont(ofSize: 15)
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.keyboardType = .default
        passwordTextField.autocorrectionType = .no
        passwordTextField.returnKeyType = .next
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textColor = .black
        
        signUpButton.backgroundColor = UIColor.blue
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.layer.cornerRadius = 10
        signUpButton.layer.masksToBounds = true
        
        errorLabel.text = "Oops, incorrect email or password!"
        errorLabel.textColor = .white
        errorLabel.backgroundColor = .red
        errorLabel.textAlignment = .center
        errorLabel.alpha = 0
    }

}
