//
//  SignInController.swift
//  WATT
//
//  Created by Stas Boiko on 15.01.2024.
//

import UIKit
import Combine

class SignInController: UIViewController {
    
    let containerView = SignInView()
    private var viewModel: SignInViewModel
    private var signUpViewModel: SignUpViewModel?
    var cancellables = Set<AnyCancellable>()

    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(containerView)
        containerView.fillSuperview()
        presentAlertController()
        presentSignUpController()
        
        navigationController?.navigationBar.isHidden = true
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
        if let signUpViewModel = signUpViewModel {
            let vc = SignUpController(viewModel: signUpViewModel)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
