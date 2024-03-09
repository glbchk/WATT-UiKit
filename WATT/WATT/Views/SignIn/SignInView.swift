//
//  SignInView.swift
//  WATT
//
//  Created by Stas Boiko on 18.01.2024.
//

import UIKit

class SignInView: UIView {
    
    let blueBackgroundView = BlueBackgroundView()
    
    let logoView = LogoView()
    
    let welcomeLabel = TextLabel(title: "Welcome back", font: .systemFont(ofSize: 22, weight: .bold), textColor: .white)
    
    let emailLabel = TextFieldLabel(title: "EMAIL")
    let passwordLabel = TextFieldLabel(title: "PASSWORD")
    
    let emailTextField = TextFieldWithPlaceholder("example@email.com")
    let passwordTextField = TextFieldWithPlaceholder("Type password here")
    
    let emailTextFieldView = TextFieldBackgroundView()
    let passwordTextFieldView = TextFieldBackgroundView()
    
    let forgotButton = LinkButton(title: "Forgot password?", size: .init(width: 0, height: 20))
    
    let addPaymentMethodTempButton = LinkButton(title: "Add payment method button", size: .init(width: 0, height: 20))
    
    let addCarTempButton = LinkButton(title: "Add car button", size: .init(width: 0, height: 20))
    
    let signInButton = MainButton(title: "Sign In", shadowOpacity: 0.3, shRadius: 5, shColor: Asset.Colors.deepBlue)
    
    let noAccountLabel = SecondaryLabel(text: "Don't have an account?")
    
    let signUpButton = LinkButton(title: "Sign up")
    
    let guestButton = MainButton(title: "Continue as guest", titleColor: Asset.Colors.black, backgroundColor: .white, shadowOpacity: 0.15, shRadius: 5, shColor: .black)

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
        setupGuestButton()
        blueBackgroundView.setupGradient(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.25))
    }
    
    private func setupBlueHeader() {
        self.addSubview(blueBackgroundView)
        
        blueBackgroundView.anchor(top: self.topAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, bottom: nil, size: .init(width: 0, height: UIScreen.main.bounds.height * 0.25))
    }
    
    private func setupHeaderStack() {
        
        let headerStack = stack(logoView, welcomeLabel, spacing: 15, alignment: .center)
        
        blueBackgroundView.addSubview(headerStack)
        headerStack.anchor(top: nil, leading: blueBackgroundView.leadingAnchor, trailing: blueBackgroundView.trailingAnchor, bottom: blueBackgroundView.bottomAnchor, padding: .init(top: 0, left: 0, bottom: 20, right: 0))
    }
    
    private func createTextFieldsStack() -> UIStackView {
        
        emailTextFieldView.textField = emailTextField
        passwordTextFieldView.textField = passwordTextField
        
        let emailStack = stack(emailLabel, emailTextFieldView, spacing: 6)
        let passwordStack = stack(passwordLabel, passwordTextFieldView, spacing: 6)
        
        let textFieldsStack = stack(emailStack, passwordStack, spacing: 20)
        
        [emailTextFieldView, passwordTextFieldView].forEach {
            $0.anchor(top: nil, leading: textFieldsStack.leadingAnchor, trailing: textFieldsStack.trailingAnchor, bottom: nil)
        }
        
        return textFieldsStack
    }
    
    private func createForgotPasswordStack() -> UIStackView {
        let underline = UIView()
        underline.backgroundColor = Asset.Colors.deepBlue
        underline.constrainHeight(1)
        let stack = stack(forgotButton, underline, addPaymentMethodTempButton, addCarTempButton, spacing: 2)
        
        underline.anchor(top: nil, leading: stack.leadingAnchor, trailing: stack.trailingAnchor, bottom: nil)
        
        return stack
    }
    
    private func setupMainStack() {
        let tfStack = createTextFieldsStack()
        let forgotPasswordStack = createForgotPasswordStack()
        let noAccauntStack = hstack(noAccountLabel, signUpButton, spacing: 10)
        
        
        let mainStack = stack(tfStack, forgotPasswordStack, signInButton, noAccauntStack, spacing: 30, alignment: .center)
        
        self.addSubview(mainStack)
        
        mainStack.anchor(top: blueBackgroundView.bottomAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, bottom: nil, padding: .allSides(20))
        
        tfStack.anchor(top: nil, leading: mainStack.leadingAnchor, trailing: mainStack.trailingAnchor, bottom: nil)
        
        signInButton.anchor(top: nil, leading: mainStack.leadingAnchor, trailing: mainStack.trailingAnchor, bottom: nil)
    }
    
    private func setupGuestButton() {
        self.addSubview(guestButton)
        guestButton.anchor(top: nil, leading: self.leadingAnchor, trailing: self.trailingAnchor, bottom: self.bottomAnchor, padding: .init(top: 0, left: 20, bottom: 50, right: 20))
    }
    
}
