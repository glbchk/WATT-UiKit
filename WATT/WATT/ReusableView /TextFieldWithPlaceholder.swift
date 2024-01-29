//
//  TextFieldWithPlaceholder.swift
//  WATT
//
//  Created by Stas Boiko on 18.01.2024.
//

import UIKit

class TextFieldWithPlaceholder: UITextField {

    init(_ placeholder: String) {
        super.init(frame: .zero)
        self.placeholder = placeholder
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
