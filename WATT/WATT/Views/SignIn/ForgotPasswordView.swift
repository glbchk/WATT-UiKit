//
//  ForgotPasswordView.swift
//  WATT
//
//  Created by Stas Boiko on 18.01.2024.
//

import UIKit

class ForgotPasswordView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Forgot your password?"
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = UIColor(red: 61/255, green: 75/255, blue: 97/255, alpha: 1) //black
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter your phone number or email address to reset your password"
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor(red: 92/255, green: 108/255, blue: 132/255, alpha: 1) //dark grey
        return label
    }()
    
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
        divider.backgroundColor = UIColor(red: 244/255, green: 246/255, blue: 249/255, alpha: 1) //grey 4
        
        let dividerLabel = UILabel()
        dividerLabel.text = "Or"
        dividerLabel.font = .systemFont(ofSize: 13)
        dividerLabel.textColor = UIColor(red: 134/255, green: 146/255, blue: 169/255, alpha: 1) //grey 1
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
        
        mainStack.fillSuperview()
    }
    
}
