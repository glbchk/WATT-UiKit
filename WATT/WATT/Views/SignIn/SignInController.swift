//
//  SignInController.swift
//  WATT
//
//  Created by Stas Boiko on 15.01.2024.
//

import UIKit
import Combine

class SignInController: BaseViewController {
    
    let contentView = SignInView()
    private var viewModel: SignInViewModel
    var cancellables = Set<AnyCancellable>()
    
    var isAlertShown = false

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
        handleKeyboardAppearance()
        
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupTargets() {
        contentView.forgotButton.addTarget(self, action: #selector(forgotPasswordButtonPressed), for: .touchUpInside)
        contentView.signUpButton.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        contentView.signInButton.addTarget(self, action: #selector(signInButtonPressed), for: .touchUpInside)
        contentView.guestButton.addTarget(self, action: #selector(guestButtonPressed), for: .touchUpInside)
    }
    
    private func handleKeyboardAppearance() {
        handleKeyboardAppearanceAction = { [weak self] keyboardAppeared, keyboardHeight in
            guard let self = self else { return }
            if !isAlertShown {
                if keyboardAppeared {
                    contentView.frame.origin.y = -(UIScreen.main.bounds.height * 0.12)
                    contentView.logoView.alpha = 0
                } else {
                    contentView.frame.origin.y = 0
                    contentView.logoView.alpha = 1
                }
            }
        }
    }
    
    @objc private func guestButtonPressed() {
        Task {
            do {
                try await viewModel.signInAnonymously { result in
                    switch result {
                    case .success(_):
                        try await self.viewModel.successfulRegistration()
                    case .failure(let failure):
                        print("Error in anonymously sign in:", failure.localizedDescription)
                    }
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    @objc private func forgotPasswordButtonPressed() {
        let vc = AlertController(contentView: ForgotPasswordView(), buttonTitle: "Reset") {
            Task {
                do {
                    try await self.viewModel.successfulRegistration()
                } catch {
                    print(error)
                }
            }
        } completionClose: {
            self.isAlertShown = false
        }
        
        isAlertShown = true
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
