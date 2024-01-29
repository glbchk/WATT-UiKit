//
//  SignUpScreenController.swift
//  WATT
//
//  Created by Glib Galchenko on 11/01/24.
//

import UIKit
import Combine

class SignUpViewController: UIViewController {
    
    private var viewModel: SignUpViewModel
    var cancellables = Set<AnyCancellable>()
    
    private var stackView: UIStackView!
//    private var signUpTitle: UILabel!
    private var nameTextField: UITextField!
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
    
    
//    lazy private var stackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.spacing = 20
//        stackView.alignment = .fill
//        stackView.distribution = .equalSpacing
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        
//        return stackView
//    }()
    
    lazy private var signUpTitle: UILabel = {
        let title = UILabel()
        title.text = "Sign up Sign up Sign up"
        title.lineBreakMode = .byWordWrapping
        title.numberOfLines = 0
        title.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        title.textColor = .black
        title.translatesAutoresizingMaskIntoConstraints = false
        
        return title
    }()
    
//    lazy private var nameTextField: UITextField = {
//        let textField = UITextField()
//        textField.placeholder = "Enter full name..."
//        textField.font = UIFont.systemFont(ofSize: 15)
//        textField.borderStyle = UITextField.BorderStyle.roundedRect
//        textField.autocorrectionType = UITextAutocorrectionType.no
//        textField.keyboardType = UIKeyboardType.default
//        textField.returnKeyType = UIReturnKeyType.next
//        textField.textColor = UIColor.black
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        
//        return textField
//    }()
    
    lazy private var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter email..."
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.borderStyle = .roundedRect
        textField.textContentType = .emailAddress
        textField.keyboardType = .emailAddress
        textField.autocorrectionType = .no
        textField.returnKeyType = .next
        textField.textColor = .black
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    lazy private var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter password..."
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.borderStyle = .roundedRect
        textField.keyboardType = .default
        textField.autocorrectionType = .no
        textField.returnKeyType = .next
        textField.isSecureTextEntry = true
        textField.textColor = .black
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
//    lazy private var signUpButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.backgroundColor = UIColor.blue
//        button.setTitle("Sign Up", for: .normal)
//        button.setTitleColor(.white, for: .normal)
//        button.layer.cornerRadius = 10
//        button.layer.masksToBounds = true
//        button.translatesAutoresizingMaskIntoConstraints = false
//        
//        return button
//    }()
    
    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Oops, incorrect email or password!"
        label.textColor = .white
        label.backgroundColor = .red
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIComponents()
        
        nameTextField.text = viewModel.fullName
        emailTextField.text = viewModel.email
        passwordTextField.text = viewModel.password
    }
    
}

extension SignUpViewController {
    
    private func setupUIComponents() {
        view.backgroundColor = UIColor.white
        
        stackSetup()
        titleLabelConstraints()
        nameSetUpConstraints()
        emailSetUpConstraints()
        passwordSetUpConstraints()
        buttonSetUpConstraints()
        
    }
    
    private func stackSetup() {

        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        let stackViewConstraints = [
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 180),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 48),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -48)
        ]
        NSLayoutConstraint.activate(stackViewConstraints)
        
    }
    
    private func titleLabelConstraints() {
        
        stackView.addArrangedSubview(signUpTitle)
        let titleLabelConstraints = [
            signUpTitle.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 20),
            signUpTitle.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0),
            signUpTitle.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 0),
            signUpTitle.heightAnchor.constraint(equalToConstant: 44)
        ]
        NSLayoutConstraint.activate(titleLabelConstraints)
        
    }
    
    private func nameSetUpConstraints() {
        
        nameTextField = UITextField()
        nameTextField.placeholder = "Enter full name..."
        nameTextField.font = UIFont.systemFont(ofSize: 15)
        nameTextField.borderStyle = UITextField.BorderStyle.roundedRect
        nameTextField.autocorrectionType = UITextAutocorrectionType.no
        nameTextField.keyboardType = UIKeyboardType.default
        nameTextField.returnKeyType = UIReturnKeyType.next
        nameTextField.textColor = UIColor.black
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
//        nameTextField.bind
        
        stackView.addArrangedSubview(nameTextField)
        let textFieldConstraints = [
            nameTextField.topAnchor.constraint(equalTo: signUpTitle.bottomAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0),
            nameTextField.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 0),
            nameTextField.heightAnchor.constraint(equalToConstant: 44)
        ]
        NSLayoutConstraint.activate(textFieldConstraints)
    }
    
    private func emailSetUpConstraints() {
        
        stackView.addArrangedSubview(emailTextField)
        let textFieldConstraints = [
            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            emailTextField.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0),
            emailTextField.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 0),
            emailTextField.heightAnchor.constraint(equalToConstant: 44)
        ]
        NSLayoutConstraint.activate(textFieldConstraints)
    }
    
    private func passwordSetUpConstraints() {
        
        stackView.addArrangedSubview(passwordTextField)
        let textFieldConstraints = [
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0),
            passwordTextField.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 0),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44)
        ]
        NSLayoutConstraint.activate(textFieldConstraints)
    }
    
    private func buttonSetUpConstraints() {
        
        signUpButton = UIButton(type: .system)
        signUpButton.backgroundColor = UIColor.blue
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.layer.cornerRadius = 10
        signUpButton.layer.masksToBounds = true
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.addTarget(self, action: #selector(viewModel.actionButton), for: .touchUpInside)
        
        stackView.addArrangedSubview(signUpButton)
        let textFieldConstraints = [
            signUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            signUpButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0),
            signUpButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 0),
            signUpButton.heightAnchor.constraint(equalToConstant: 44)
        ]
        NSLayoutConstraint.activate(textFieldConstraints)
    }
    
    private func errorLabelConstraints() {
        
        stackView.addArrangedSubview(errorLabel)
        let titleLabelConstraints = [
            errorLabel.topAnchor.constraint(equalTo: signUpButton.topAnchor, constant: 20),
            errorLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0),
            errorLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 0),
//            errorLabel.heightAnchor.constraint(equalToConstant: 44)
        ]
        NSLayoutConstraint.activate(titleLabelConstraints)
        
    }
    
}
