//
//  ErrorAddedCarView.swift
//  WATT
//
//  Created by Glib Galchenko on 29/06/24.
//

import UIKit

class AddCarNameView: UIView {
    
    let carNameLabel = TextFieldLabel(title: "CAR NAME")
    let carNameTextField = TextFieldWithPlaceholder("Lucy's car...")
    
    let carErrorNameLabel = TextLabel(title: "Invalid name, should be at least 3 letters long...", font: .systemFont(ofSize: 13), textColor: Asset.Colors.red)
    let carErrorDuplicationLabel = TextLabel(title: "This model is already added...", font: .systemFont(ofSize: 13), textColor: Asset.Colors.red)
    
    let saveButton = MainButton(title: "Save", shadowOpacity: 0.3, shRadius: 5, shColor: Asset.Colors.deepBlue)
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        carErrorNameLabel.isHidden = true
        carErrorDuplicationLabel.isHidden = true
        
        let carNameTextFieldView = TextFieldBackgroundView(tf: carNameTextField)
        let carNameAndErrorsStack = stack(carNameLabel, carNameTextFieldView, carErrorNameLabel, spacing: 6)
        
        let stack = stack(carNameAndErrorsStack, saveButton, spacing: 30)
        
        self.addSubview(stack)
        stack.anchor(top: self.topAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, bottom: self.bottomAnchor)
        [carNameTextFieldView, carNameAndErrorsStack, saveButton].forEach {
            $0.anchor(top: nil, leading: stack.leadingAnchor, trailing: stack.trailingAnchor, bottom: nil)
        }
    }
        
}
