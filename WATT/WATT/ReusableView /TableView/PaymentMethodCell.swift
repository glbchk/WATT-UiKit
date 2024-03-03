//
//  PaymentMethodCell.swift
//  WATT
//
//  Created by Glib Galchenko on 01/03/24.
//

import UIKit

class PaymentMethodCell: UITableViewCell {

//    var methodType: UIImage? {
//        didSet {
//            setupUI()
//        }
//    }
    
    let methodLogoView: UIImageView = {
        let view = UIImageView()
        view.constrainWidth(24)
        view.constrainHeight(24)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.black
        
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.systemGray
        
        return label
    }()
    
    let rightArrow: UIImageView = {
        let view = UIImageView(image: Asset.Icons.Navigation.chevronRight)
        view.contentMode = .scaleAspectFit
        view.tintColor = Asset.Colors.grey1
        view.constrainWidth(12)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle = .default, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//        setupUI()
//    }

    func setupUI() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 15
        self.setupShadow(opacity: 0.15, radius: 5, color: .black)
        
        let imageView = UIView()
        imageView.constrainHeight(60)
        imageView.constrainWidth(60)
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 5
        imageView.addSubview(methodLogoView)
        methodLogoView.centerInSuperview()
        
//        image.contentMode = .scaleAspectFit
//        image.constrainWidth(24)
//        methodLogoView.addSubview(image)
//        image.centerInSuperview()
        
        titleLabel.text = "Some tempreraly text" // Need to add something decent
        subtitleLabel.text = "Card number" // Need to add something decent
        
        let labelsStack = stack(titleLabel, subtitleLabel, spacing: 4)
        let mainStack = hstack(imageView, labelsStack, rightArrow, spacing: 15, alignment: .center, distribution: .fill)
        
        self.addSubview(mainStack)
        mainStack.anchor(top: self.topAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, bottom: self.bottomAnchor, padding: .allSides(15))
    }

}
