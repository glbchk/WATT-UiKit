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
        setupAlertController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        containerView.blueBackgroundView.setupGradient()
    }
    
    private func setupAlertController() {
        containerView.forgotButton.addTarget(self, action: #selector(openForgotPasswordController), for: .touchUpInside)
    }
    
    @objc private func openForgotPasswordController() {
        let vc = AlertController(contentView: ForgotPasswordView(), buttonTitle: "Reset")
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        navigationController?.present(vc, animated: true)
        
    }
}
