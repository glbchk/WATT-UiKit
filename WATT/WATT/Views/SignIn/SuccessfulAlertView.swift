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
        circle.backgroundColor = UIColor(red: 244/255, green: 246/255, blue: 249/255, alpha: 1) //grey 4
        circle.layer.borderWidth = 1
        circle.layer.borderColor = UIColor(red: 219/255, green: 223/255, blue: 227/255, alpha: 1).cgColor //grey 3
        
        let checkmarkImage = UIImage(systemName: "checkmark")
        let checkmarkView = UIImageView(image: checkmarkImage)
        checkmarkView.image?.withTintColor(UIColor(red: 21/255, green: 129/255, blue: 255/255, alpha: 1)) //deep blue

        circle.addSubview(checkmarkView)
        checkmarkView.centerInSuperview(size: .init(width: 35, height: 27))
        return circle
    }()
    
    init(title: String, subtitle: String) {
        super.init(frame: .zero)
        titleLabel = TextLabel(title: title, font: .systemFont(ofSize: 22, weight: .bold), textColor: UIColor(red: 61/255, green: 75/255, blue: 97/255, alpha: 1))
        subtitleLabel = TextLabel(title: subtitle, font: .systemFont(ofSize: 15), textColor: UIColor(red: 92/255, green: 108/255, blue: 132/255, alpha: 1), numberOfLines: 0, textAlignment: .center)
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
        
        mainStack.fillSuperview(padding: .init(top: 80, left: 0, bottom: 0, right: 0))
    }
    
}
