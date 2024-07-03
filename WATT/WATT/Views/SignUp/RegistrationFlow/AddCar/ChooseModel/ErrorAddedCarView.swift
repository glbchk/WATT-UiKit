//
//  ErrorAddedCarView.swift
//  WATT
//
//  Created by Glib Galchenko on 29/06/24.
//

import UIKit

class ErrorAddedCarView: UIView {
    
    let titleLabel = TextLabel(title: "This model is already added!", font: .systemFont(ofSize: 22, weight: .bold), textColor:  Asset.Colors.black)
    
    let subtitleLabel = TextLabel(title: "Select another brand or another model of the chosen brand", font: .systemFont(ofSize: 15), textColor: Asset.Colors.darkGrey, numberOfLines: 0, textAlignment: .center)
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        let mainStack = stack(titleLabel, subtitleLabel, spacing: 20, alignment: .center)
        
        self.addSubview(mainStack)
        
        mainStack.centerYToSuperview()
        mainStack.anchor(top: nil, leading: self.leadingAnchor, trailing: self.trailingAnchor, bottom: nil)
    }
    
}
