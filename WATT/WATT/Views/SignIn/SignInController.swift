//
//  SignInController.swift
//  WATT
//
//  Created by Stas Boiko on 15.01.2024.
//

import UIKit
import Combine

class SignInController: UIViewController {
    
    let contentView = SignInView()
    private var viewModel: SignInViewModel
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
        view.addSubview(contentView)
        contentView.fillSuperview()
        presentAlertController()
        presentSignUpController()
        bindSecureFieldPublisher()
        
        navigationController?.navigationBar.isHidden = true
    }
    
    private func presentAlertController() {
        contentView.forgotButton.addTarget(self, action: #selector(openForgotPasswordController), for: .touchUpInside)
    }
    
    private func presentSignUpController() {
        contentView.signUpButton.addTarget(self, action: #selector(openSignUpController), for: .touchUpInside)
    }
    
    @objc private func openForgotPasswordController() {
        let vc = AlertController(contentView: ForgotPasswordView(), buttonTitle: "Reset")
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        navigationController?.present(vc, animated: true)
    }
    
    @objc private func openSignUpController() {
        if let signUpViewModel = viewModel.signUpViewModel {
            let vc = SignUpController(viewModel: signUpViewModel)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func bindSecureFieldPublisher() {
        contentView.passwordTextFieldView.secureFieldPublisher = viewModel.sfPublisher
        contentView.passwordTextFieldView.action = { self.viewModel.showPassword.toggle() }
    }
}
