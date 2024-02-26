//
//  AddNameAndPhoneNumberView.swift
//  WATT
//
//  Created by Stas Boiko on 10.02.2024.
//

import UIKit

class AddNameAndPhoneNumberView: UIView {
    
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
        return button
    }()
    
    let titleLabel = TextLabel(title: "Add your name & phone number", font: .systemFont(ofSize: 28, weight: .bold), textColor: .white, numberOfLines: 0)
    
    let subtitleLable = SecondaryLabel(text: "We need phone number to have additional way to contact you", textColor: .white, numbersOfLines: 0, textAlignment: .natural)
    
    let nameLabel = TextFieldLabel(title: "NAME")
    let phoneNumberLabel = TextFieldLabel(title: "PHONE NUMBER")
    
    let nameTextField = TextFieldWithPlaceholder("e.g. John Doe")
    let phoneNumberTextField = TextFieldWithPlaceholder("+380")
    
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
        setupLabels()
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
        whiteBackgroundView.anchor(top: subtitleLable.bottomAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, bottom: self.bottomAnchor, padding: .init(top: 25, left: 0, bottom: 0, right: 0))
    }
    
    private func setupBackButton() {
        blueBackgroundView.addSubview(backButton)
        backButton.anchor(top: self.safeAreaLayoutGuide.topAnchor, leading: blueBackgroundView.leadingAnchor, trailing: nil, bottom: nil, padding: .init(top: 20, left: 26, bottom: 0, right: 0), size: .init(width: 18, height: 24))
    }
    
    private func setupLabels() {
        let stack = stack(titleLabel, subtitleLable, spacing: 6)
        blueBackgroundView.addSubview(stack)
        stack.anchor(top: backButton.bottomAnchor, leading: blueBackgroundView.leadingAnchor, trailing: blueBackgroundView.trailingAnchor, bottom: nil, padding: .init(top: 20, left: 20, bottom: 0, right: 20))
    }
    
    private func setupTextFields() {
        let nameTextFieldView = TextFieldBackgroundView(tf: nameTextField)
        let phoneNumberTextFieldView = TextFieldBackgroundView(tf: phoneNumberTextField)
        
        let nameStack = stack(nameLabel, nameTextFieldView, spacing: 6)
        let emailStack = stack(phoneNumberLabel, phoneNumberTextFieldView, spacing: 6)
        
        let stack = stack(nameStack, emailStack, spacing: 20)
        
        stack.anchor(top: whiteBackgroundView.topAnchor, leading: whiteBackgroundView.leadingAnchor, trailing: whiteBackgroundView.trailingAnchor, bottom: nil, padding: .allSides(20))
        
        [nameTextFieldView, phoneNumberTextFieldView].forEach {
            $0.anchor(top: nil, leading: stack.leadingAnchor, trailing: stack.trailingAnchor, bottom: nil)
        }
    }
    
    private func setupSaveButton() {
        whiteBackgroundView.addSubview(saveButton)
        saveButton.anchor(top: phoneNumberTextField.bottomAnchor, leading: whiteBackgroundView.leadingAnchor, trailing: whiteBackgroundView.trailingAnchor, bottom: nil, padding: .init(top: 30, left: 20, bottom: 0, right: 20))
    }
}
