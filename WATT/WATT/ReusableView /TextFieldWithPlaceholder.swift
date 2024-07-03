//
//  TextFieldWithPlaceholder.swift
//  WATT
//
//  Created by Stas Boiko on 18.01.2024.
//

import UIKit

enum TextFieldType {
    case email, password, phoneNumber, numbers, regular
}

class TextFieldWithPlaceholder: UITextField {
    
    var inputText: String? {
        didSet {
            self.text = inputText
        }
    }

    init(_ placeholder: String, inputText: String? = nil, textFieldType: TextFieldType = .regular, keyboardType: UIKeyboardType = .default, returnKeyType: UIReturnKeyType = .default) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.inputText = inputText
        self.keyboardType = keyboardType
        self.returnKeyType = returnKeyType
        
        switch textFieldType {
        case .email:
            self.autocapitalizationType = .none
            self.autocorrectionType = .no
            self.spellCheckingType = .no
            self.keyboardType = .emailAddress
        case .password:
            self.autocapitalizationType = .none
            self.autocorrectionType = .no
            self.spellCheckingType = .no
        case .numbers:
            self.keyboardType = .numberPad
        case .regular:
            self.autocapitalizationType = .sentences
            self.autocorrectionType = .no
            self.spellCheckingType = .yes
        case .phoneNumber:
            self.keyboardType = .phonePad
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
