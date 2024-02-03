//
//  ForgotPasswordView.swift
//  WATT
//
//  Created by Stas Boiko on 18.01.2024.
//

import UIKit

class ForgotPasswordView: UIView {
    
    let titleLabel = TextLabel(title: "Forgot your password?", font: .systemFont(ofSize: 22, weight: .bold), textColor:  Asset.Colors.black)
    
    let subtitleLabel = TextLabel(title: "Enter your phone number or email address to reset your password", font: .systemFont(ofSize: 15), textColor: Asset.Colors.darkGrey, numberOfLines: 0, textAlignment: .center)
    
    let phoneNumberLabel = TextFieldLabel(title: "PHONE NUMBER")
    let emailLabel = TextFieldLabel(title: "EMAIL")
    
    let phoneNumberTextField = TextFieldWithPlaceholder("+380")
    let emailTextField = TextFieldWithPlaceholder("Type email here")
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let divider = UIView()
        divider.constrainHeight(1)
        divider.backgroundColor = Asset.Colors.grey4
        
        let dividerLabel = UILabel()
        dividerLabel.text = "Or"
        dividerLabel.font = .systemFont(ofSize: 13)
        dividerLabel.textColor = Asset.Colors.grey1
        dividerLabel.backgroundColor = .white
        dividerLabel.textAlignment = .center
        
        divider.addSubview(dividerLabel)
        dividerLabel.centerInSuperview(size: .init(width: 20, height: 20))
        
        let phoneNumberTextFieldView = TextFieldBackgroundView(tf: phoneNumberTextField)
        let emailTextFieldView = TextFieldBackgroundView(tf: emailTextField)
        
        let phoneNumberStack = stack(phoneNumberLabel, phoneNumberTextFieldView, spacing: 6)
        let emailStack = stack(emailLabel, emailTextFieldView, spacing: 6)
        
        let mainStack = stack(titleLabel, subtitleLabel, phoneNumberStack, divider, emailStack, spacing: 20, alignment: .center)
        
        divider.anchor(top: nil, leading: mainStack.leadingAnchor, trailing: mainStack.trailingAnchor, bottom: nil)
        [phoneNumberTextFieldView, emailTextFieldView].forEach {
            $0.anchor(top: nil, leading: emailStack.leadingAnchor, trailing: mainStack.trailingAnchor, bottom: nil)
        }
        
        self.addSubview(mainStack)
        
        mainStack.centerYToSuperview()
        mainStack.anchor(top: nil, leading: self.leadingAnchor, trailing: self.trailingAnchor, bottom: nil)
    }
    
}
