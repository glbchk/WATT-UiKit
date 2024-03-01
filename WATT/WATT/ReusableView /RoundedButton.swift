//
//  RoundedButton.swift
//  WATT
//
//  Created by Stas Boiko on 28.02.2024.
//

import UIKit

class RoundedButton: UIButton {
    
    init(image: UIImage?, backgroundColor: UIColor = .white, size: CGFloat, tintColor: UIColor? = nil) {
        super.init(frame: .zero)
        self.setImage(image, for: .normal)
        self.backgroundColor = backgroundColor
        self.constrainWidth(size)
        self.constrainHeight(size)
        self.layer.cornerRadius = size/2
        self.tintColor = tintColor
        self.setupShadow(opacity: 0.3, radius: 5, color: .black)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
