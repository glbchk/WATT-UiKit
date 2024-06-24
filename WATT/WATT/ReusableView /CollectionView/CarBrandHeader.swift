//
//  CarBrandCell2.swift
//  WATT
//
//  Created by Glib Galchenko on 20/04/24.
//

import UIKit

class CarBrandHeader: UICollectionReusableView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        self.frame.size.height = 40
        let header = TextFieldLabel(title: "ADD ANOTHER CAR")
        
        self.addSubview(header)
        header.anchor(top: nil, leading: self.leadingAnchor, trailing: self.trailingAnchor, bottom: self.bottomAnchor)
    }

}
