//
//  ProfileView.swift
//  WATT
//
//  Created by Glib Galchenko on 01/03/24.
//

import UIKit
import Combine

class ProfileView: UIView {
    
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
    
    let titleLabel = TextLabel(title: "Profile", font: .systemFont(ofSize: 28, weight: .bold), textColor: .white, numberOfLines: 0)
    
    let subtitleLable = SecondaryLabel(text: "Here you will find your information", textColor: .white, numbersOfLines: 0, textAlignment: .natural)
    
    let nameRow = ProfileRow(rowName: "Name")
    let emailRow = ProfileRow(rowName: "Email")
    let phoneNumberRow = ProfileRow(rowName: "Mobile")
    let languageRow = ProfileRow(rowName: "Language")
    
    let changePasswordButton = MainButton(title: "Change password", titleColor: Asset.Colors.black, backgroundColor: .white, shadowOpacity: 0.15, shRadius: 5, shColor: .black)
    
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
        setupRows()
        setupChangePasswordButton()
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
    
    private func setupRows() {
        let rowsStack = stack(nameRow, emailRow, phoneNumberRow, languageRow, spacing: 6)
        
        [nameRow, emailRow, phoneNumberRow, languageRow].forEach {
            $0.anchor(top: nil, leading: rowsStack.leadingAnchor, trailing: rowsStack.trailingAnchor, bottom: nil, padding: .init(top: 0, left: 20, bottom: 0, right: 20))
        }
        
        rowsStack.anchor(top: whiteBackgroundView.topAnchor, leading: whiteBackgroundView.leadingAnchor, trailing: whiteBackgroundView.trailingAnchor, bottom: nil, padding: .init(top: 20, left: 0, bottom: 0, right: 0))
    }
    
    private func setupChangePasswordButton() {
        whiteBackgroundView.addSubview(changePasswordButton)
        changePasswordButton.anchor(top: languageRow.bottomAnchor, leading: whiteBackgroundView.leadingAnchor, trailing: whiteBackgroundView.trailingAnchor, bottom: nil, padding: .init(top: 30, left: 20, bottom: 0, right: 20))
    }

}
