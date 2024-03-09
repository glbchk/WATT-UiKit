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
    
    let titleLabel = TextLabel(title: "Credit card details", font: .systemFont(ofSize: 18, weight: .bold), textColor: .white, numberOfLines: 0)
    
    let cardNameLabel = TextFieldLabel(title: "CARD NAME")
    let cardNumberLabel = TextFieldLabel(title: "CARD NUMBER")
    let expiryLabel = TextFieldLabel(title: "EXPIRY")
    let cvvLabel = TextFieldLabel(title: "CVV")
    
    let cardNameTextField = TextFieldWithPlaceholder("e.g. Default payment method")
    let cardNumberTextField = TextFieldWithPlaceholder("0000  0000  0000  0000")
    let expiryTextField = TextFieldWithPlaceholder("MM / YY")
    let cvvTextField = TextFieldWithPlaceholder("•••")
    
    let cardNumberTextFieldView = TextFieldBackgroundView()
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
//        setupLabels()
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
        let stack = hstack(backButton, titleLabel, spacing: 60, alignment: .fill, distribution: .fill)
        blueBackgroundView.addSubview(stack)
        stack.anchor(top: self.safeAreaLayoutGuide.topAnchor, leading: blueBackgroundView.leadingAnchor, trailing: nil, bottom: nil, padding: .init(top: 20, left: 26, bottom: 0, right: 0))
    }
    
    private func setupTextFields() {
        let cardNameTextFieldView = TextFieldBackgroundView(tf: cardNameTextField)
        cardNumberTextFieldView.textField = cardNumberTextField
//        cardNumberTextFieldView.textField?.text = cardNumberTextField.inputText?.separate()
        let expiryTextFieldView = TextFieldBackgroundView(tf: expiryTextField)
        cvvTextFieldView.textField = cvvTextField
        
        let cardNameStack = stack(cardNameLabel, cardNameTextFieldView, spacing: 6)
        let cardNumberStack = stack(cardNumberLabel, cardNumberTextFieldView, spacing: 6)
        let expiryStack = stack(expiryLabel, expiryTextFieldView, spacing: 6)
        let cvvStack = stack(cvvLabel, cvvTextFieldView, spacing: 6)
        let expiryCvvStack = hstack(expiryStack, cvvStack, spacing: 20, alignment: .fill, distribution: .fillEqually)
        let toggleStack = hstack(defaultPaymentLabel, toggle, spacing: 10, alignment: .fill, distribution: .fill)
        expiryTextFieldView.anchor(top: nil, leading: expiryStack.leadingAnchor, trailing: expiryStack.trailingAnchor, bottom: nil)
        cvvTextFieldView.anchor(top: nil, leading: cvvStack.leadingAnchor, trailing: cvvStack.trailingAnchor, bottom: nil)
        
        let stack = stack(cardNameStack, cardNumberStack, expiryCvvStack, toggleStack, spacing: 20)
        
        stack.anchor(top: whiteBackgroundView.topAnchor, leading: whiteBackgroundView.leadingAnchor, trailing: whiteBackgroundView.trailingAnchor, bottom: nil, padding: .allSides(20))
        
        [cardNameTextFieldView, cardNumberTextFieldView, expiryCvvStack, toggleStack].forEach {
            $0.anchor(top: nil, leading: stack.leadingAnchor, trailing: stack.trailingAnchor, bottom: nil)
        }
    }
    
    private func setupSaveButton() {
        whiteBackgroundView.addSubview(saveButton)
        saveButton.anchor(top: toggle.bottomAnchor, leading: whiteBackgroundView.leadingAnchor, trailing: whiteBackgroundView.trailingAnchor, bottom: nil, padding: .init(top: 30, left: 20, bottom: 0, right: 20))
    }
    
//    func separate(to textField: UITextField, with text: String = "") {
//        if textField.text?.isEmpty {
//            
//        }
//    }
    
}

//extension String {
//    func chunkFormatted(withChunkSize chunkSize: Int = 4, withSeparator separator: Character = " ") -> String {
//        return characters.filter { $0 != separator }.chunk(n: chunkSize)
//            .map{ String($0) }.joined(separator: String(separator))
//    }
//}

//extension String {
//    func separate(every stride: Int = 4, with separator: Character = " ") -> String {
//        return String(enumerated().map { $0 > 0 && $0 % stride == 0 ? [separator, $1] : [$1]}.joined())
//    }
//}
