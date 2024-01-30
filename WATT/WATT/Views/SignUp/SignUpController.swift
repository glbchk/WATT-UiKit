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
        presentSignInController()
    }
    
    private func presentSignInController() {
        contentView.signInButton.addTarget(self, action: #selector(openSignInController), for: .touchUpInside)
    }
    
    @objc private func openSignInController() {
        dismiss(animated: true)
    }

}
