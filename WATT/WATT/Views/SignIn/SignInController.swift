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
        setupTargets()
        bindViewsToViewModel()
        bindSecureFieldPublisher()
        
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupTargets() {
        contentView.forgotButton.addTarget(self, action: #selector(forgotPasswordButtonPressed), for: .touchUpInside)
        contentView.signUpButton.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        contentView.signInButton.addTarget(self, action: #selector(signInButtonPressed), for: .touchUpInside)
        contentView.guestButton.addTarget(self, action: #selector(guestButtonPressed), for: .touchUpInside)
    }
    
    @objc private func guestButtonPressed() {
        Task {
            do {
                try await viewModel.signInAnonymously()
                try await viewModel.successfulRegistration()
                self.navigationController?.popViewController(animated: true)
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    @objc private func forgotPasswordButtonPressed() {
        let vc = AlertController(contentView: ForgotPasswordView(), buttonTitle: "Reset")
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        navigationController?.present(vc, animated: true)
    }
    
    @objc private func signUpButtonPressed() {
        if let signUpViewModel = viewModel.signUpViewModel {
            let vc = SignUpController(viewModel: signUpViewModel)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc private func signInButtonPressed() {
        viewModel.logIn { error in
            self.viewModel.error = error
        }
    }
    
    private func bindViewsToViewModel() {
        contentView.emailTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.email, on: viewModel)
            .store(in: &cancellables)
        
        contentView.passwordTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.password, on: viewModel)
            .store(in: &cancellables)
        
        viewModel.isSubmitEnabled
            .sink { [weak self] isValid in
                guard let self = self else { return }
                if isValid {
                    self.contentView.signInButton.isEnabled = true
                } else {
                    self.contentView.signInButton.isEnabled = false
                }
            }
            .store(in: &cancellables)
    }
    
    private func bindSecureFieldPublisher() {
        contentView.passwordTextFieldView.secureFieldPublisher = viewModel.sfPublisher
        contentView.passwordTextFieldView.action = { self.viewModel.showPassword.toggle() }
    }
}
