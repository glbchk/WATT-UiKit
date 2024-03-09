//
//  ProfileRow.swift
//  WATT
//
//  Created by Glib Galchenko on 01/03/24.
//

import UIKit
import Combine

class ProfileRow: UIView {
    private var cancellable = Set<AnyCancellable>()
    
    let label: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = Asset.Colors.black
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    let detailsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = Asset.Colors.grey1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    let rightArrow: UIImageView = {
        let view = UIImageView(image: Asset.Icons.Navigation.chevronRight)
        view.contentMode = .scaleAspectFit
        view.tintColor = Asset.Colors.grey1
        view.constrainWidth(24)
        return view
    }()
    
    init(detailsText: String? = nil, rowName: String) {
        self.detailsLabel.text = detailsText
        self.label.text = rowName
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.backgroundColor = .white
        self.constrainHeight(60)
        let borderColor = UIColor(red: 219/255, green: 223/255, blue: 227/255, alpha: 1)
        self.setupShadow(opacity: 0.8, offset: CGSize(width: 0, height: 1), color: borderColor)
        
        let rightStack = hstack(detailsLabel, rightArrow, spacing: 10)
        let stack = hstack(label, rightStack)
        
        self.addSubview(stack)
        stack.anchor(top: self.topAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, bottom: self.bottomAnchor)
    }
    
}
