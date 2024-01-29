//
//  LogoView.swift
//  WATT
//
//  Created by Stas Boiko on 15.01.2024.
//

import UIKit

class LogoView: UIView {
    
    let logoLabel: UILabel = {
        let label = UILabel()
        label.text = "W"
        label.textColor = UIColor(red: 21/255, green: 129/255, blue: 255/255, alpha: 1)
        label.font = .systemFont(ofSize: 35, weight: .bold)
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        layer.cornerRadius = 15
        backgroundColor = .white
        addSubview(logoLabel)
        logoLabel.centerInSuperview()
        constrainWidth(60)
        constrainHeight(60)
    }
}
