//
//  AddCreditCardView.swift
//  WATT
//
//  Created by Glib Galchenko on 01/03/24.
//

import UIKit

class AddAndEditPMView: UIView {
    
    let blueBackgroundView = BlueBackgroundView()
    
    let blueBackgroundHeight = UIScreen.main.bounds.height * 0.35
    
    let whiteBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        return view
    }()
    
    var mainStack: UIStackView? = nil
    var buttonsStack: UIStackView? = nil
    
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
        label.textColor = Asset.Colors.red
        label.font = .systemFont(ofSize: 13, weight: .semibold)
//        label.text = "Card name should have at least 4 symbols!"
        label.isHidden = true
        
        return label
    }()
    
    let cardNumberNotificationLabel: UILabel = {
        let label = UILabel()
        label.textColor = Asset.Colors.red
        label.font = .systemFont(ofSize: 13, weight: .semibold)
//        label.text = "Card number is not 16 digits!"
        label.isHidden = true
        
        return label
    }()
    
    let expiryDateNotificationLabel: UILabel = {
        let label = UILabel()
        label.textColor = Asset.Colors.red
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.text = "Date isn't chosen!"
        label.isHidden = true
        
        return label
    }()
    
    let cvvNotificationLabel: UILabel = {
        let label = UILabel()
        label.textColor = Asset.Colors.red
        label.font = .systemFont(ofSize: 13, weight: .semibold)
//        label.text = "Should be 3 digits!"
        label.isHidden = true
        
        return label
    }()
    
    let cardValidityNotificationLabel: UILabel = {
        let label = UILabel()
        label.textColor = Asset.Colors.red
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.text = "The card is already added, add another card!"
        label.textAlignment = .center
        label.isHidden = true
        
        return label
    }()
    
    let titleLabel = TextLabel(title: "Credit card details", font: .systemFont(ofSize: 18, weight: .bold), textColor: .white, numberOfLines: 0)
    
    let cardNameLabel = TextFieldLabel(title: "CARD NAME")
    let cardNumberLabel = TextFieldLabel(title: "CARD NUMBER")
    let expiryLabel = TextFieldLabel(title: "EXPIRY")
    let cvvLabel = TextFieldLabel(title: "CVV")
    
    let cardNameTextField = TextFieldWithPlaceholder("e.g. Default payment method", returnKeyType: .next)
    var cardNumberTextField = TextFieldWithPlaceholder("0000  0000  0000  0000", textFieldType: .numbers)
    let expiryTextField = TextFieldWithPlaceholder("MM / YY")
    let cvvTextField = TextFieldWithPlaceholder("•••", textFieldType: .numbers)
    
    let cardNameTextFieldView = TextFieldBackgroundView()
    let cardNumberTextFieldView = TextFieldBackgroundView()
    let expiryTextFieldView = TextFieldBackgroundView()
    let cvvTextFieldView = TextFieldBackgroundView()
    
    let defaultPaymentLabel = TextLabel(title: "Default payment method", font: .systemFont(ofSize: 15, weight: .regular), textColor: .black, numberOfLines: 0, textAlignment: .left)
    let toggle = ToggleView()
    
    let saveButton = MainButton(title: "Save")
    let deleteButton = MainButton(title: "Delete", titleColor: Asset.Colors.red, backgroundColor: .white, shadowOpacity: 0.15, shRadius: 5, shColor: .black)
    
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
        setupMainStack()
//        setupSaveButton()
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
    
    private func setupMainStack() {
        
        cardNameTextFieldView.textField = cardNameTextField
        
        cardNumberTextFieldView.textField = cardNumberTextField
        
        expiryTextFieldView.textField = expiryTextField
        
        cvvTextFieldView.textField = cvvTextField
        
        let cardNameStack = stack(cardNameLabel, cardNameTextFieldView, cardNameNotificationLabel, spacing: 6)
        let cardNumberStack = stack(cardNumberLabel, cardNumberTextFieldView, cardNumberNotificationLabel, spacing: 6)
        let expiryStack = stack(expiryLabel, expiryTextFieldView, expiryDateNotificationLabel, spacing: 6)
        let cvvStack = stack(cvvLabel, cvvTextFieldView, cvvNotificationLabel, spacing: 6)
        let expiryCvvStack = hstack(expiryStack, cvvStack, spacing: 20, alignment: .top, distribution: .fillEqually)
        let toggleStack = hstack(defaultPaymentLabel, toggle, spacing: 10, alignment: .fill, distribution: .fill)
        let saveButtonStack = stack(saveButton, cardValidityNotificationLabel, spacing: 10, alignment: .center)
        buttonsStack = stack(saveButtonStack, deleteButton, spacing: 20, alignment: .center)
        guard let buttonsStack = buttonsStack else { return }
        
        expiryTextFieldView.anchor(top: nil, leading: expiryStack.leadingAnchor, trailing: expiryStack.trailingAnchor, bottom: nil)
        cvvTextFieldView.anchor(top: nil, leading: cvvStack.leadingAnchor, trailing: cvvStack.trailingAnchor, bottom: nil)
        
        mainStack = stack(cardNameStack, cardNumberStack, expiryCvvStack, toggleStack, buttonsStack, spacing: 20)
        guard let mainStack = mainStack else { return }
        
        mainStack.anchor(top: whiteBackgroundView.topAnchor, leading: whiteBackgroundView.leadingAnchor, trailing: whiteBackgroundView.trailingAnchor, bottom: nil, padding: .allSides(20))
        
        [cardNameTextFieldView, cardNumberTextFieldView, expiryCvvStack, toggleStack, buttonsStack].forEach {
            $0.anchor(top: nil, leading: mainStack.leadingAnchor, trailing: mainStack.trailingAnchor, bottom: nil)
        }
        
        [saveButton, cardValidityNotificationLabel].forEach {
            $0.anchor(top: nil, leading: saveButtonStack.leadingAnchor, trailing: saveButtonStack.trailingAnchor, bottom: nil)
        }
        
        [saveButtonStack, deleteButton].forEach {
            $0.anchor(top: nil, leading: mainStack.leadingAnchor, trailing: mainStack.trailingAnchor, bottom: nil)
        }
        
    }
    
}


