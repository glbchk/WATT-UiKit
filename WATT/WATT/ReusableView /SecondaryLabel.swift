//
//  SecondaryLabel.swift
//  WATT
//
//  Created by Stas Boiko on 18.01.2024.
//

import UIKit

class SecondaryLabel: UILabel {

    init(text: String, font: UIFont = .systemFont(ofSize: 15), textColor: UIColor = UIColor(red: 134/255, green: 146/255, blue: 169/255, alpha: 1)) {
        super.init(frame: .zero)
        self.text = text
        self.font = font
        self.textColor = textColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
