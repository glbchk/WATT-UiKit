//
//  CarBrandCell.swift
//  WATT
//
//  Created by Glib Galchenko on 17/04/24.
//

import UIKit

class CarBrandCell: UICollectionViewCell {
    
    let squareView: UIView = {
        let sqaure = UIView()
        sqaure.backgroundColor = Asset.Colors.grey4
        sqaure.constrainWidth(60)
        sqaure.constrainHeight(60)
        sqaure.clipsToBounds = true
        sqaure.layer.cornerRadius = 5
        
        return sqaure
    }()
    
    var squareImageView: UIImageView? = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.constrainWidth(48)
        imageView.constrainHeight(48)
        imageView.clipsToBounds = true
        
        return imageView
    }()


    let topLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        label.textColor = Asset.Colors.grey1
        
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = Asset.Colors.black
        
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = Asset.Colors.deepBlue
        
        return label
    }()


    let rightArrow: UIImageView = {
        let view = UIImageView(image: Asset.Icons.Navigation.chevronRight)
        view.contentMode = .scaleAspectFit
        view.tintColor = Asset.Colors.grey1
        view.constrainWidth(24)
        return view
    }()

    override func willTransition(from oldLayout: UICollectionViewLayout, to newLayout: UICollectionViewLayout) {
        super.willTransition(from: oldLayout, to: newLayout)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 15
        self.setupShadow(opacity: 0.15, radius: 5, color: .black)
        
        titleLabel.text = "Some tempreraly text" // Need to add something decent
        subtitleLabel.text = "Connected"
        
//        UIImageView(image: UIImage(named: "car"))
        guard let image = squareImageView else { return }
        squareView.addSubview(image)
        image.centerInSuperview()
        
        topLabel.isHidden = true
        subtitleLabel.isHidden = true
        
        let labelsStack = stack(topLabel, titleLabel, subtitleLabel, spacing: 3)
        let stack = hstack(squareView, labelsStack, rightArrow, spacing: 15)
        
        self.addSubview(stack)
        stack.anchor(top: self.topAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, bottom: self.bottomAnchor, padding: .allSides(15))
    }
    
    func set(object: UIImage) {
        
        self.squareImageView?.image = object
        
    }

}
