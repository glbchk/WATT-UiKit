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
        view.constrainWidth(30)
        view.constrainHeight(30)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = Asset.Colors.black
        
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = Asset.Colors.grey1
        
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
        self.backgroundColor = .clear
        
        let imageView = UIView()
        imageView.constrainHeight(60)
        imageView.constrainWidth(60)
        imageView.backgroundColor = Asset.Colors.grey4
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
        
        let someView = UIView()
        someView.backgroundColor = .white
        someView.layer.cornerRadius = 15
        someView.setupShadow(opacity: 0.15, radius: 5, color: .black)
        someView.addSubview(mainStack)
        
        self.addSubview(someView)
        mainStack.anchor(top: someView.topAnchor, leading: someView.leadingAnchor, trailing: someView.trailingAnchor, bottom: someView.bottomAnchor, padding: .allSides(15))
        someView.fillSuperview(padding: .init(top: 5, left: 0, bottom: 5, right: 0))
    }

}
