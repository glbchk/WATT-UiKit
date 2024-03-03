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
    
    let emailLabel = TextFieldLabel(title: "EMAIL")
    
    let emailTextField = TextFieldWithPlaceholder("Type email here")
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let emailTextFieldView = TextFieldBackgroundView(tf: emailTextField)
        
        let emailStack = stack(emailLabel, emailTextFieldView, spacing: 6)
        let mainStack = stack(titleLabel, subtitleLabel, emailStack, spacing: 20, alignment: .center)
        
        [emailTextFieldView, emailStack].forEach {
            $0.anchor(top: nil, leading: emailStack.leadingAnchor, trailing: mainStack.trailingAnchor, bottom: nil)
        }
        
        self.addSubview(mainStack)
        
        mainStack.centerYToSuperview()
        mainStack.anchor(top: nil, leading: self.leadingAnchor, trailing: self.trailingAnchor, bottom: nil)
    }
    
}
