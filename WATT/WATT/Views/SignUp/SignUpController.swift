//
//  SignUpController.swift
//  WATT
//
//  Created by Stas Boiko on 18.01.2024.
//

import UIKit
import Combine

class SignUpController: UIViewController {
    
    let contentView = SignUpView()
    private var viewModel: SignUpViewModel
    private var signInViewModel: SignInViewModel?
    var cancellables = Set<AnyCancellable>()

    private(set) lazy var isInputValid = Publishers.CombineLatest(viewModel.$email, viewModel.$password)
        .map { $0.count > 2 && $1.count > 6 }
        .eraseToAnyPublisher()
    
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
        setupTarget()
        bindViewToViewModel()
        bindViewModelToView()
    }
    
    private func setupTarget() {
        contentView.signInButton.addTarget(self, action: #selector(openSignInButton), for: .touchUpInside)
        contentView.signUpButton.addTarget(self, action: #selector(openAddDetailsButton), for: .touchUpInside)
    }
    
    @objc private func openSignInButton() {
        if let signInViewModel = signInViewModel {
            let vc = SignInController(viewModel: signInViewModel)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc private func openAddDetailsButton() {
        viewModel.createUser { isActive, error in
            DispatchQueue.main.async {
                self.contentView.signUpButton.isEnabled = isActive
                self.viewModel.successfulRegistration()
//                if !error.isEmpty {
//                    self.contentView.errorLabel.alpha = 1
//                    self.contentView.errorLabel.text = error
//                }
            }
        }
        
        let vc = AddDetailsController(viewModel: viewModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func bindViewToViewModel() {
        contentView.emailTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.email, on: viewModel)
            .store(in: &cancellables)
        
        contentView.phoneNumberTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.phoneNumber, on: viewModel)
            .store(in: &cancellables)
        
        contentView.passwordTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.password, on: viewModel)
            .store(in: &cancellables)
        
        contentView.retypePasswordTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.password, on: viewModel)
            .store(in: &cancellables)
        
        viewModel.signInButtonPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.isValid , on: contentView.signInButton)
            .store(in: &cancellables)
    }
    
    private func bindViewModelToView() {
        viewModel.isInputValid
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: contentView.signUpButton)
            .store(in: &cancellables)
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
