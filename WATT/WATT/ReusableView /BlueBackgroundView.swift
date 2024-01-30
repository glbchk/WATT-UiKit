//
//  BlueBackgroundView.swift
//  WATT
//
//  Created by Stas Boiko on 18.01.2024.
//

import UIKit

class BlueBackgroundView: UIView {
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Should be called in ViewController`s viewDidAppear()
    func setupGradient(frame: CGRect) {
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = [UIColor(red: 21/255, green: 129/255, blue: 255/255, alpha: 1).cgColor, UIColor(red: 0/255, green: 103/255, blue: 224/255, alpha: 1).cgColor]
        self.layer.insertSublayer(gradient, at: 0)
    }
    
}
