//
//  SecondaryLabel.swift
//  WATT
//
//  Created by Stas Boiko on 18.01.2024.
//

import UIKit

class SecondaryLabel: UILabel {

    init(text: String, font: UIFont = .systemFont(ofSize: 15), textColor: UIColor = Asset.Colors.grey1, numbersOfLines: Int = 1, textAlignment: NSTextAlignment = .natural) {
        super.init(frame: .zero)
        self.text = text
        self.font = font
        self.textColor = textColor
        self.numberOfLines = numbersOfLines
        self.textAlignment = textAlignment
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
