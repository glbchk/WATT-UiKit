//
//  SignUpController.swift
//  WATT
//
//  Created by Stas Boiko on 18.01.2024.
//

import UIKit

class SignUpController: UIViewController {
    
    let contentView = SignUpView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(contentView)
        contentView.fillSuperview()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentView.blueBackgroundView.setupGradient()
    }

}
