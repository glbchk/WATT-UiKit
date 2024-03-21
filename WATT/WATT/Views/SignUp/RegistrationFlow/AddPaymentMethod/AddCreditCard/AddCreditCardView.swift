//
//  AddCreditCardView.swift
//  WATT
//
//  Created by Glib Galchenko on 01/03/24.
//

import UIKit

class AddCreditCardView: UIView {
    
    let blueBackgroundView = BlueBackgroundView()
    
    let blueBackgroundHeight = UIScreen.main.bounds.height * 0.35
    
    let whiteBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        return view
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(Asset.Icons.Navigation.chevronLeft, for: .normal)
        button.tintColor = .white
        button.imageView?.fillSuperview()
        button.widthAnchor.constraint(equalToConstant: 18).isActive = true
        button.heightAnchor.constraint(equalToConstant: 24).isActive = true
        return button
    }()
    
    let cardNameNotificationLabel: UILabel = {
        let label = UILabel()
        label.textColor = Asset.Colors.green
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.isHidden = true
        
        return label
    }()
    
    let cardNumberNotificationLabel: UILabel = {
        let label = UILabel()
        label.textColor = Asset.Colors.green
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.isHidden = true
        
        return label
    }()
    
    let expiryDateNotificationLabel: UILabel = {
        let label = UILabel()
        label.textColor = Asset.Colors.green
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.isHidden = true
        
        return label
    }()
    
    let cvvNotificationLabel: UILabel = {
        let label = UILabel()
        label.textColor = Asset.Colors.green
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.isHidden = true
        
        return label
    }()
    
    let cardValidityNotificationLabel: UILabel = {
        let label = UILabel()
        label.textColor = Asset.Colors.green
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.isHidden = true
        
        return label
    }()
    
    let titleLabel = TextLabel(title: "Credit card details", font: .systemFont(ofSize: 18, weight: .bold), textColor: .white, numberOfLines: 0)
    
    let cardNameLabel = TextFieldLabel(title: "CARD NAME")
    let cardNumberLabel = TextFieldLabel(title: "CARD NUMBER")
    let expiryLabel = TextFieldLabel(title: "EXPIRY")
    let cvvLabel = TextFieldLabel(title: "CVV")
    
    let cardNameTextField = TextFieldWithPlaceholder("e.g. Default payment method")
    var cardNumberTextField = TextFieldWithPlaceholder("0000  0000  0000  0000")
    let expiryTextField = TextFieldWithPlaceholder("MM / YY")
    let cvvTextField = TextFieldWithPlaceholder("•••")
    
    let cardNameTextFieldView = TextFieldBackgroundView()
    let cardNumberTextFieldView = TextFieldBackgroundView()
    let expiryTextFieldView = TextFieldBackgroundView()
    let cvvTextFieldView = TextFieldBackgroundView()
    
    let defaultPaymentLabel = TextLabel(title: "Default payment method", font: .systemFont(ofSize: 15, weight: .regular), textColor: .black, numberOfLines: 0, textAlignment: .left)
    let toggle = ToggleView()
    
    let saveButton = MainButton(title: "Save")
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupBlueHeader()
        setupBackButton()
        setupTitleLabel()
        setupWhiteFooter()
        setupTextFields()
        setupSaveButton()
    }
    
    private func setupBlueHeader() {
        self.addSubview(blueBackgroundView)
        blueBackgroundView.anchor(top: self.topAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, bottom: nil, size: .init(width: 0, height: blueBackgroundHeight))
        blueBackgroundView.setupGradient(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: blueBackgroundHeight))
    }
    
    private func setupWhiteFooter() {
        self.addSubview(whiteBackgroundView)
        whiteBackgroundView.anchor(top: backButton.bottomAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, bottom: self.bottomAnchor, padding: .init(top: 25, left: 0, bottom: 0, right: 0))
    }
    
    private func setupBackButton() {
        blueBackgroundView.addSubview(backButton)
        backButton.anchor(top: self.safeAreaLayoutGuide.topAnchor, leading: blueBackgroundView.leadingAnchor, trailing: nil, bottom: nil, padding: .init(top: 20, left: 26, bottom: 0, right: 0))
    }
    
    private func setupTitleLabel() {
        blueBackgroundView.addSubview(titleLabel)
        titleLabel.anchor(top: self.safeAreaLayoutGuide.topAnchor, leading: nil, trailing: nil, bottom: nil, padding: .init(top: 20, left: 0, bottom: 0, right: 0))
        titleLabel.centerXToSuperview()
    }
    
    private func setupTextFields() {
        cardNameTextFieldView.textField = cardNameTextField
        cardNumberTextFieldView.textField = cardNumberTextField
        cardNumberTextFieldView.textField?.keyboardType = .numberPad
        expiryTextFieldView.textField = expiryTextField
        cvvTextFieldView.textField = cvvTextField
        cvvTextFieldView.textField?.keyboardType = .numberPad
        
        let cardNameStack = stack(cardNameLabel, cardNameTextFieldView, cardNameNotificationLabel, spacing: 6)
        let cardNumberStack = stack(cardNumberLabel, cardNumberTextFieldView, cardNumberNotificationLabel, spacing: 6)
        let expiryStack = stack(expiryLabel, expiryTextFieldView, spacing: 6)
        let cvvStack = stack(cvvLabel, cvvTextFieldView, spacing: 6)
        let expiryCvvStack = hstack(expiryStack, cvvStack, spacing: 20, alignment: .fill, distribution: .fillEqually)
        let notificationsStack = hstack(expiryDateNotificationLabel, cvvNotificationLabel, spacing: 6, alignment: .leading)
        let expiryCvvNotificationsStack = stack(expiryCvvStack, notificationsStack, spacing: 6, alignment: .fill)
        expiryTextFieldView.anchor(top: nil, leading: expiryStack.leadingAnchor, trailing: expiryStack.trailingAnchor, bottom: nil)
        cvvTextFieldView.anchor(top: nil, leading: cvvStack.leadingAnchor, trailing: cvvStack.trailingAnchor, bottom: nil)
        expiryCvvStack.anchor(top: nil, leading: expiryCvvNotificationsStack.leadingAnchor, trailing: expiryCvvNotificationsStack.trailingAnchor, bottom: nil)
        notificationsStack.anchor(top: nil, leading: expiryCvvNotificationsStack.leadingAnchor, trailing: expiryCvvNotificationsStack.trailingAnchor, bottom: nil)
        if expiryDateNotificationLabel.isHidden == true {
            notificationsStack.alignment = .trailing
        } else {
            notificationsStack.alignment = .leading
        }
//        cvvNotificationLabel.anchor(top: nil, leading: nil, trailing: notificationsStack.trailingAnchor, bottom: nil)
        let toggleStack = hstack(defaultPaymentLabel, toggle, spacing: 10, alignment: .fill, distribution: .fill)
        
        let stack = stack(cardNameStack, cardNumberStack, expiryCvvNotificationsStack, toggleStack, spacing: 20)
        
        stack.anchor(top: whiteBackgroundView.topAnchor, leading: whiteBackgroundView.leadingAnchor, trailing: whiteBackgroundView.trailingAnchor, bottom: nil, padding: .allSides(20))
        
        [cardNameTextFieldView, cardNumberTextFieldView, expiryCvvNotificationsStack, toggleStack].forEach {
            $0.anchor(top: nil, leading: stack.leadingAnchor, trailing: stack.trailingAnchor, bottom: nil)
        }
        
    }
    
    private func setupSaveButton() {
        saveButton.isEnabled = false
        saveButton.backgroundColor = Asset.Colors.grey1
        
        let stack = stack(saveButton, cardValidityNotificationLabel, spacing: 6, alignment: .center)
        whiteBackgroundView.addSubview(stack)
        stack.anchor(top: toggle.bottomAnchor, leading: whiteBackgroundView.leadingAnchor, trailing: whiteBackgroundView.trailingAnchor, bottom: nil, padding: .init(top: 30, left: 20, bottom: 0, right: 20))
        [saveButton, cardValidityNotificationLabel].forEach {
            $0.anchor(top: nil, leading: stack.leadingAnchor, trailing: stack.trailingAnchor, bottom: nil)
        }
    }
    
}


