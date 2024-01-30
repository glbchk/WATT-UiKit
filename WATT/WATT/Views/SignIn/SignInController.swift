//
//  SignInController.swift
//  WATT
//
//  Created by Stas Boiko on 15.01.2024.
//

import UIKit

class SignInController: UIViewController {
    
    let containerView = SignInView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(containerView)
        containerView.fillSuperview()
        presentAlertController()
        presentSignUpController()
    }
    
    private func presentAlertController() {
        containerView.forgotButton.addTarget(self, action: #selector(openForgotPasswordController), for: .touchUpInside)
    }
    
    private func presentSignUpController() {
        containerView.signUpButton.addTarget(self, action: #selector(openSignUpController), for: .touchUpInside)
    }
    
    @objc private func openForgotPasswordController() {
        let vc = AlertController(contentView: ForgotPasswordView(), buttonTitle: "Reset")
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        navigationController?.present(vc, animated: true)
    }
    
    @objc private func openSignUpController() {
        let vc = SignUpController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        navigationController?.present(vc, animated: true)
    }
}
