//
//  ChooseModelView.swift
//  WATT
//
//  Created by Glib Galchenko on 03/03/24.
//

import UIKit

class ChooseModelView: UIView {
    
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
    
    let titleLabel = TextLabel(title: "Choose model", font: .systemFont(ofSize: 18, weight: .bold), textColor: .white, numberOfLines: 0)
    
    let carModelTableView = UITableView()
    
    let carNameLabel = TextFieldLabel(title: "CAR NAME")
    let carNameTextField = TextFieldWithPlaceholder("Lucy's car...")
    
    let bgSaveCarButton = UIView()
    let saveButton = MainButton(title: "Save")
    
    init() {
        super.init(frame: .zero)
        carModelTableView.backgroundColor = .clear
        
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
//        setupSaveButton()
        setupTableView()
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
    
    private func setupTableView() {
        self.addSubview(carModelTableView)
        
        carModelTableView.anchor(top: whiteBackgroundView.topAnchor, leading: whiteBackgroundView.leadingAnchor, trailing: whiteBackgroundView.trailingAnchor, bottom: whiteBackgroundView.bottomAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0))
    }
    
//    private func setupSaveButton() {
//        whiteBackgroundView.addSubview(saveButton)
//        saveButton.anchor(top: nil, leading: self.leadingAnchor, trailing: self.trailingAnchor, bottom: self.bottomAnchor, padding: .init(top: 0, left: 20, bottom: 50, right: 20))
//    }
//    
//    private func saveAddedCarsButton() {
//        let carNameTextFieldView = TextFieldBackgroundView(tf: carNameTextField)
//        let nameStack = stack(carNameLabel, carNameTextFieldView, spacing: 6)
//        
//        bgSaveCarButton.backgroundColor = .white
//        bgSaveCarButton.heightAnchor.constraint(equalToConstant: 224).isActive = true
//        bgSaveCarButton.setupShadow(opacity: 0.1, radius: 30, color: .black)
//        
//        let stack = stack(nameStack, saveButton, spacing: 12)
//        
//        bgSaveCarButton.addSubview(stack)
//        
//        whiteBackgroundView.addSubview(bgSaveCarButton)
//        bgSaveCarButton.anchor(top: nil, leading: self.leadingAnchor, trailing: self.trailingAnchor, bottom: self.bottomAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
//        stack.anchor(top: bgSaveCarButton.topAnchor, leading: bgSaveCarButton.leadingAnchor, trailing: bgSaveCarButton.trailingAnchor, bottom: nil, padding: .init(top: 20, left: 20, bottom: 0, right: 20))
//    }
    
}
