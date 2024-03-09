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
//        bindViewModelToView()
        bindSecureFieldPublishers()
        handleKeyboardAppearance()
    }
    
    private func setupTargets() {
        contentView.signInButton.addTarget(self, action: #selector(signInButtonPressed), for: .touchUpInside)
        contentView.signUpButton.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
    }
    
    private func handleKeyboardAppearance() {
        handleKeyboardAppearanceAction = { [weak self] keyboardAppeared, keyboardHeight in
            guard let self = self else { return }
            if keyboardAppeared {
                contentView.frame.origin.y = -(UIScreen.main.bounds.height * 0.12)
                contentView.logoView.alpha = 0
            } else {
                contentView.frame.origin.y = 0
                contentView.logoView.alpha = 1
            }
        }
    }
    
    @objc private func signInButtonPressed() {
        self.navigationController?.popViewController(animated: true)
//        self.dismiss(animated: false, completion: nil)
    }
    
    @objc private func signUpButtonPressed() {
        viewModel.createUser { [weak self] isActive, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                let vc = AddDetailsController(viewModel: self.viewModel)
                self.navigationController?.pushViewController(vc, animated: true)
            }
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
        
        viewModel.isSignUpValid
            .sink { [weak self] isValid in
                guard let self = self else { return }
                if isValid {
                    self.contentView.signUpButton.isEnabled = true
                } else {
                    self.contentView.signUpButton.isEnabled = false
                }
            }
            .store(in: &cancellables)
    }
    
//    private func bindViewModelToView() {
//        viewModel.isInputValid
//            .receive(on: DispatchQueue.main)
//            .assign(to: \.isEnabled, on: contentView.signUpButton)
//            .store(in: &cancellables)
//    }
    
    private func bindSecureFieldPublishers() {
        contentView.passwordTextFieldView.secureFieldPublisher = viewModel.passwordPublisher
        contentView.passwordTextFieldView.action = { self.viewModel.showPassword.toggle() }
        
        contentView.retypePasswordTextFieldView.secureFieldPublisher = viewModel.retypedPasswordPublisher
        contentView.retypePasswordTextFieldView.action = { self.viewModel.showRetyped.toggle() }
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
