//
//  SignUpController.swift
//  WATT
//
//  Created by Stas Boiko on 18.01.2024.
//

import UIKit
import Combine

class SignUpController: UIViewController {
    
    //Need to double check
    let contentView = SignUpView()
    private var viewModel: SignUpViewModel
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
        bindSecureFieldPublishers()
    }
    
    private func setupTarget() {
        contentView.signInButton.addTarget(self, action: #selector(openSignInButton), for: .touchUpInside)
        contentView.signUpButton.addTarget(self, action: #selector(openAddDetailsButton), for: .touchUpInside)
    }
    
    @objc private func openSignInButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func openAddDetailsButton() {
        viewModel.createUser { [weak self] isActive, error in
            DispatchQueue.main.async {
                guard let vm = self?.viewModel else { return }
                let vc = AddDetailsController(viewModel: vm)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
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
    }
    
    private func bindViewModelToView() {
        viewModel.isInputValid
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: contentView.signUpButton)
            .store(in: &cancellables)
    }
    
    private func bindSecureFieldPublishers() {
        contentView.passwordTextFieldView.secureFieldPublisher = viewModel.passwordPublisher
        contentView.passwordTextFieldView.action =  { self.viewModel.showPassword.toggle() }
        
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
