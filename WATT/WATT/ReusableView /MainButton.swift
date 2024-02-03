//
//  MainButton.swift
//  WATT
//
//  Created by Stas Boiko on 18.01.2024.
//

import UIKit

class MainButton: UIButton {
    
    init(title: String, font: UIFont = .systemFont(ofSize: 18, weight: .bold), titleColor: UIColor = .white, backgroundColor: UIColor = Asset.Colors.deepBlue, cornerRadius: CGFloat = 15, size: CGSize = .init(width: 0, height: 60), shadowOpacity: Float = 0, shRadius: CGFloat = 0, shOffset: CGSize = .zero, shColor: UIColor = .black) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = font
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        if size.width != 0 {
            self.constrainWidth(size.width)
        }
        if size.height != 0 {
            self.constrainHeight(size.height)
        }
        self.setupShadow(opacity: shadowOpacity, radius: shRadius, offset: shOffset, color: shColor)
    }
    
    init(image: UIImage, backgroundColor: UIColor = .white, cornerRadius: CGFloat = 15, size: CGSize = .init(width: 0, height: 60), shadowOpacity: Float = 0, shRadius: CGFloat = 0, shOffset: CGSize = .zero, shColor: UIColor = .black) {
        super.init(frame: .zero)
        self.setImage(image, for: .normal)
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        if size.width != 0 {
            self.constrainWidth(size.width)
        }
        if size.height != 0 {
            self.constrainHeight(size.height)
        }
        self.setupShadow(opacity: shadowOpacity, radius: shRadius, offset: shOffset, color: shColor)
    }
    
    
    init(title: String, titleColor: UIColor = .white, image: UIImage? = nil, font: UIFont = .systemFont(ofSize: 18, weight: .bold), backgroundColor: UIColor = .white, cornerRadius: CGFloat = 15, size: CGSize = .init(width: 0, height: 60), shadowOpacity: Float = 0, shRadius: CGFloat = 0, shOffset: CGSize = .zero, shColor: UIColor = .black) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.titleLabel?.textColor = titleColor
        if let image = image {
            self.setImage(image, for: .normal)
        }
        self.titleLabel?.font = font
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        if size.width != 0 {
            self.constrainWidth(size.width)
        }
        if size.height != 0 {
            self.constrainHeight(size.height)
        }
        self.setupShadow(opacity: shadowOpacity, radius: shRadius, offset: shOffset, color: shColor)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
