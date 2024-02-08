//
//  SignUpScreenController.swift
//  WATT
//
//  Created by Glib Galchenko on 11/01/24.
//

import UIKit
import Combine

class SignUpViewController: UIViewController {
    
    private lazy var contentView = SignUpViewGlib()
    private var viewModel: SignUpViewModel
    var cancellables = Set<AnyCancellable>()
    
//    private var stackView: UIStackView!
//    private var signUpTitle: UILabel!
//    private var nameTextField: UITextField!
//    private var emailTextField: UITextField!
//    private var passwordTextField: UITextField!
    @IBOutlet private var signUpButton: UIButton!
    
    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupViewConstratints()
        setupTarget()
        bindViewToViewModel()
        bindViewModelToView()
    }
    
    private func setupViewConstratints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTarget() {
        contentView.signUpButton.addTarget(self, action: #selector(onPressButton), for: .touchUpInside)
    }
    
    private func bindViewToViewModel() {
        contentView.nameTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.fullName, on: viewModel)
            .store(in: &cancellables)
        
        contentView.emailTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.email, on: viewModel)
            .store(in: &cancellables)
        
        contentView.passwordTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.password, on: viewModel)
            .store(in: &cancellables)
    }
    
    private func bindViewModelToView() {
        viewModel.isInputValid
            .receive(on: RunLoop.main)
            .assign(to: \.isValid, on: contentView.signUpButton)
            .store(in: &cancellables)
        
    }
    
    @objc private func onPressButton() {
        viewModel.createUser { isActive, error in
            DispatchQueue.main.async {
                self.contentView.signUpButton.isEnabled = isActive
                self.viewModel.successfulRegistration()
                if !error.isEmpty {
                    self.contentView.errorLabel.alpha = 1
                    self.contentView.errorLabel.text = error
                }
            }
        }
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

extension UIColor {
    static var valid = UIColor.blue
    static var nonValid = UIColor.gray
}

extension UIButton {
    
    var isValid: Bool {
        get { isEnabled && backgroundColor == .valid }
        set {
            backgroundColor = newValue ? .valid : .nonValid
            isEnabled = newValue
        }
    }
}
