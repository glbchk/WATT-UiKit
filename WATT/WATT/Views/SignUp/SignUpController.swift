//
//  SignUpController.swift
//  WATT
//
//  Created by Stas Boiko on 18.01.2024.
//

import UIKit
import Combine

class SignUpController: BaseViewController {
    var cancellables = Set<AnyCancellable>()
    
    let contentView = SignUpView()
    private var viewModel: SignUpViewModel
    
    private var isValidSignUp = false
    
    init(viewModel: SignUpViewModel) {
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
        bindSecureFieldPublishers()
        handleKeyboardAppearance()
        
        contentView.emailTextField.delegate = self
        contentView.passwordTextField.delegate = self
        contentView.retypePasswordTextField.delegate = self
    }
    
    private func setupTargets() {
        contentView.signInButton.addTarget(self, action: #selector(signInButtonPressed), for: .touchUpInside)
        contentView.signUpButton.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
    }
    
    private func handleKeyboardAppearance() {
        handleKeyboardAppearanceAction = { [weak self] keyboardAppeared, keyboardHeight in
            guard let self = self else { return }
            if keyboardAppeared {
                view.frame.origin.y = -(UIScreen.main.bounds.height * 0.12)
                contentView.logoView.alpha = 0
                contentView.mainStack?.spacing = 10
            } else {
                view.frame.origin.y = 0
                contentView.logoView.alpha = 1
                contentView.mainStack?.spacing = 30
            }
        }
    }
    
    @objc private func signInButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func signUpButtonPressed() {
        switch isValidSignUp {
        case true:
            print("sign up valid")
            
            viewModel.createUser { [weak self] isActive, error in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    let vc = AddDetailsController(viewModel: self.viewModel)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            self.view.endEditing(true)
        case false:
            if viewModel.email.isEmpty {
                contentView.emailErrorLabel.text = TFError.Registration.requiredField.description
                contentView.emailErrorLabel.isHidden = false
            }
            
            if viewModel.password.isEmpty {
                contentView.passwordErrorLabel.text = TFError.Registration.requiredField.description
                contentView.passwordErrorLabel.isHidden = false
            }
            
            if viewModel.retypedPassword.isEmpty && viewModel.password.isEmpty {
                contentView.retypedPasswordErrorLabel.text = TFError.Registration.requiredField.description
                contentView.retypedPasswordErrorLabel.isHidden = false
            } else if viewModel.retypedPassword.isEmpty {
                contentView.retypedPasswordErrorLabel.text = TFError.Registration.invalidRetypedPassword.description
                contentView.retypedPasswordErrorLabel.isHidden = false
            }
            
            self.view.endEditing(true)
            shakeAnimation(of: contentView.signUpButton)
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
        
        contentView.retypePasswordTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.retypedPassword, on: viewModel)
            .store(in: &cancellables)
        
        viewModel.isValidEmailPublisher
            .sink { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    contentView.emailErrorLabel.isHidden = true
                case .failure(let failure):
                    contentView.emailErrorLabel.text = failure.description
                    contentView.emailErrorLabel.isHidden = false
                }
            }
            .store(in: &cancellables)
        
        viewModel.isValidPasswordPublisher
            .sink { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    contentView.passwordErrorLabel.isHidden = true
                case .failure(let failure):
                    contentView.passwordErrorLabel.text = failure.description
                    contentView.passwordErrorLabel.isHidden = false
                }
            }
            .store(in: &cancellables)
        
        viewModel.isValidRetypedPasswordPublisher
            .sink { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    contentView.retypedPasswordErrorLabel.isHidden = true
                case .failure(let failure):
                    contentView.retypedPasswordErrorLabel.text = failure.description
                    contentView.retypedPasswordErrorLabel.isHidden = false
                }
            }
            .store(in: &cancellables)
        
        viewModel.isSignUpValid
            .sink { [weak self] isValid in
                guard let self = self else { return }
                
                isValidSignUp = isValid
            }
            .store(in: &cancellables)
        
        viewModel.signUpInProgressPublisher
            .sink { [weak self] currentSigningUp in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch currentSigningUp {
                    case true:
                        self.contentView.signUpButton.activityIndicator.startAnimating()
                    case false:
                        self.contentView.signUpButton.activityIndicator.stopAnimating()
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func bindSecureFieldPublishers() {
        contentView.passwordTextFieldView.secureFieldPublisher = viewModel.passwordPublisher
        contentView.passwordTextFieldView.action = { self.viewModel.showPassword.toggle() }
        
        contentView.retypePasswordTextFieldView.secureFieldPublisher = viewModel.retypedPasswordPublisher
        contentView.retypePasswordTextFieldView.action = { self.viewModel.showRetyped.toggle() }
    }
    
}

extension SignUpController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == contentView.emailTextField {
            contentView.passwordTextField.becomeFirstResponder()
        } else if textField == contentView.passwordTextField {
            contentView.retypePasswordTextField.becomeFirstResponder()
        } else if textField == contentView.retypePasswordTextField {
            signUpButtonPressed()
            contentView.retypePasswordTextField.resignFirstResponder()
        }
        return true
    }

}

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { $0.object as? UITextField }
            .compactMap(\.text)
            .eraseToAnyPublisher()
    }
}
