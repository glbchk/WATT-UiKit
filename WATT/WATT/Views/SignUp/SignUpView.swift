//
//  SignUpView.swift
//  WATT
//
//  Created by Stas Boiko on 18.01.2024.
//

import UIKit
import Combine

class SignUpView: UIView {

    let blueBackgroundView = BlueBackgroundView()
    
    let blueBackgroundHeight = UIScreen.main.bounds.height * 0.25
    
    let logoView = LogoView()
    
    let createAccountLabel = TextLabel(title: "Create an account", font: .systemFont(ofSize: 22, weight: .bold), textColor: .white)
    
    let emailLabel = TextFieldLabel(title: "EMAIL")
    let passwordLabel = TextFieldLabel(title: "PASSWORD")
    let retypePasswordLabel = TextFieldLabel(title: "RETYPE PASSWORD")
    
    let emailErrorLabel = TextLabel(title: "Email error", font: .systemFont(ofSize: 13), textColor: Asset.Colors.red)
    let passwordErrorLabel = TextLabel(title: "Password error", font: .systemFont(ofSize: 13), textColor: Asset.Colors.red)
    let retypedPasswordErrorLabel = TextLabel(title: "Retyped password error", font: .systemFont(ofSize: 13), textColor: Asset.Colors.red)
    
    let emailTextField = TextFieldWithPlaceholder("example@email.com")
    let passwordTextField = TextFieldWithPlaceholder("At least 6 characters")
    let retypePasswordTextField = TextFieldWithPlaceholder("Retype password here")
    
    let emailTextFieldView = TextFieldBackgroundView()
    let passwordTextFieldView = TextFieldBackgroundView()
    let retypePasswordTextFieldView = TextFieldBackgroundView()
    
    let termsLabel: SecondaryLabel = SecondaryLabel(text: "Creating account you accept")
    
    let termsButton = LinkButton(title: "Terms & Conditions")

    let signUpButton = MainButton(title: "Sign up", shadowOpacity: 0.3, shRadius: 5, shColor: Asset.Colors.deepBlue)
    
    let haveAccountLabel = SecondaryLabel(text: "Already have an account?")
    
    let signInButton = LinkButton(title: "Sign in")
    
    var mainStack: UIStackView? = nil
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupBlueHeader()
        setupHeaderStack()
        setupMainStack()
        blueBackgroundView.setupGradient(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: blueBackgroundHeight))
    }
    
    private func setupBlueHeader() {
        self.addSubview(blueBackgroundView)
        blueBackgroundView.anchor(top: self.topAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, bottom: nil, size: .init(width: 0, height: blueBackgroundHeight))
    }
    
    private func setupHeaderStack() {
        let stack = stack(logoView, createAccountLabel, spacing: 15, alignment: .center)
        
        blueBackgroundView.addSubview(stack)
        stack.anchor(top: nil, leading: blueBackgroundView.leadingAnchor, trailing: blueBackgroundView.trailingAnchor, bottom: blueBackgroundView.bottomAnchor, padding: .init(top: 0, left: 0, bottom: 20, right: 0))
    }
    
    private func setupMainStack() {
        let textFieldsStack = createTextFieldsStack()
        let termsStack = hstack(termsLabel, termsButton, spacing: 5)
        let haveAccountStack = hstack(haveAccountLabel, signInButton, spacing: 10)
        
        mainStack = stack(textFieldsStack, termsStack, signUpButton, haveAccountStack, spacing: 30, alignment: .center)
        
        guard let mainStack = mainStack else { return }
        
        mainStack.anchor(top: blueBackgroundView.bottomAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, bottom: nil, padding: .allSides(20))
        
        signUpButton.anchor(top: nil, leading: mainStack.leadingAnchor, trailing: mainStack.trailingAnchor, bottom: nil)
        textFieldsStack.anchor(top: nil, leading: mainStack.leadingAnchor, trailing: mainStack.trailingAnchor, bottom: nil)
    }
    
    private func createTextFieldsStack() -> UIStackView {
        
        emailTextFieldView.textField = emailTextField
        passwordTextFieldView.textField = passwordTextField
        retypePasswordTextFieldView.textField = retypePasswordTextField
        
        emailTextField.keyboardType = .emailAddress
        emailTextField.returnKeyType = .next
        
        passwordTextField.returnKeyType = .next
        retypePasswordTextField.returnKeyType = .done
        
        emailErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
        retypedPasswordErrorLabel.isHidden = true
        
        let emailStack = stack(emailLabel, emailTextFieldView, emailErrorLabel, spacing: 6)
        let passwordStack = stack(passwordLabel, passwordTextFieldView, passwordErrorLabel, spacing: 6)
        let retypeStack = stack(retypePasswordLabel, retypePasswordTextFieldView, retypedPasswordErrorLabel, spacing: 6)
        
        let stack = stack(emailStack, passwordStack, retypeStack, spacing: 20)
        
        [emailTextFieldView, passwordTextFieldView, retypePasswordTextFieldView].forEach {
            $0.anchor(top: nil, leading: stack.leadingAnchor, trailing: stack.trailingAnchor, bottom: nil)
        }
        return stack
    }
  
}
