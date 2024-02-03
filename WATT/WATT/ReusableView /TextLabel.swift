//
//  TextLabel.swift
//  WATT
//
//  Created by Stas Boiko on 29.01.2024.
//

import UIKit

class TextLabel: UILabel {
    
    init(title: String, font: UIFont, textColor: UIColor, numberOfLines: Int = 1, textAlignment: NSTextAlignment = .natural) {
        super.init(frame: .zero)
        self.text = title
        self.font = font
        self.textColor = textColor
        self.numberOfLines = numberOfLines
        self.textAlignment = textAlignment
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
