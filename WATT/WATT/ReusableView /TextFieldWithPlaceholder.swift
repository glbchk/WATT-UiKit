//
//  TextFieldWithPlaceholder.swift
//  WATT
//
//  Created by Stas Boiko on 18.01.2024.
//

import UIKit

class TextFieldWithPlaceholder: UITextField {
    
    var inputText: String? {
        didSet {
            self.text = inputText
        }
    }

    init(_ placeholder: String, inputText: String? = nil) {
        super.init(frame: .zero)
        self.attributedPlaceholder = .init(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : Asset.Colors.grey2])
        self.inputText = inputText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
