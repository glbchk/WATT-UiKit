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
        presentAddDetailsController()
    }
    
    private func presentSignInController() {
        contentView.signInButton.addTarget(self, action: #selector(openSignInController), for: .touchUpInside)
    }
    
    @objc private func openSignInController() {
        navigationController?.popViewController(animated: true)
    }
    
    private func presentAddDetailsController() {
        contentView.signUpButton.addTarget(self, action: #selector(openAddDetailsController), for: .touchUpInside)
    }
    
    @objc private func openAddDetailsController() {
        let vc = AddDetailsController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
