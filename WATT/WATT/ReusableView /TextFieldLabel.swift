//
//  TextFieldLabel.swift
//  WATT
//
//  Created by Stas Boiko on 18.01.2024.
//

import UIKit

class TextFieldLabel: UILabel {

    init(title: String, font: UIFont = .systemFont(ofSize: 13, weight: .bold), titleColor: UIColor = Asset.Colors.grey1) {
        super.init(frame: .zero)
        self.text = title
        self.font = font
        self.textColor = titleColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
