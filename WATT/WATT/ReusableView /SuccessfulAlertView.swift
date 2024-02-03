//
//  SuccessfulAlertView.swift
//  WATT
//
//  Created by Stas Boiko on 29.01.2024.
//

import UIKit

class SuccessfulAlertView: UIView {
    
    var titleLabel: UILabel?
    var subtitleLabel: UILabel?
    
    let checkmarkCircle: UIView = {
        let circle = UIView()
        circle.layer.cornerRadius = 40
        circle.constrainWidth(80)
        circle.constrainHeight(80)
        circle.backgroundColor = Asset.Colors.grey4
        circle.layer.borderWidth = 1
        circle.layer.borderColor = Asset.Colors.grey3.cgColor
        
        let checkmarkImage = UIImage(systemName: "checkmark")
        let checkmarkView = UIImageView(image: checkmarkImage)
        checkmarkView.image?.withTintColor(Asset.Colors.deepBlue)

        circle.addSubview(checkmarkView)
        checkmarkView.centerInSuperview(size: .init(width: 35, height: 27))
        return circle
    }()
    
    init(title: String, subtitle: String) {
        super.init(frame: .zero)
        titleLabel = TextLabel(title: title, font: .systemFont(ofSize: 22, weight: .bold), textColor: Asset.Colors.black)
        subtitleLabel = TextLabel(title: subtitle, font: .systemFont(ofSize: 15), textColor: Asset.Colors.darkGrey, numberOfLines: 0, textAlignment: .center)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        guard let titleLabel = titleLabel, let subtitleLabel = subtitleLabel else { return }
        
        let labelStack = stack(titleLabel, subtitleLabel, spacing: 10, alignment: .center)
        
        let mainStack = stack(checkmarkCircle, labelStack, spacing: 20, alignment: .center)
        
        
        self.addSubview(mainStack)
        
        mainStack.centerYToSuperview()
        mainStack.anchor(top: nil, leading: self.leadingAnchor, trailing: self.trailingAnchor, bottom: nil)
    }
    
}
