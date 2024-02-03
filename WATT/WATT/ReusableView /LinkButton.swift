//
//  LinkButton.swift
//  WATT
//
//  Created by Stas Boiko on 18.01.2024.
//

import UIKit

class LinkButton: UIButton {

    init(title: String, titleColor: UIColor = Asset.Colors.deepBlue, font: UIFont = .systemFont(ofSize: 15), size: CGSize = .zero) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = font
        if size.width != 0 {
            self.constrainWidth(size.width)
        }
        if size.height != 0 {
            self.constrainHeight(size.height)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
