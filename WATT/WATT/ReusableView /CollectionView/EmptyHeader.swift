//
//  EmptyHeader.swift
//  WATT
//
//  Created by Glib Galchenko on 06/05/24.
//

import UIKit

class EmptyHeader: UICollectionReusableView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        self.backgroundColor = .clear
    }

}
