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
        presentSignInController()
        signUp()
    }
    
    private func presentSignInController() {
        contentView.signInButton.addTarget(self, action: #selector(openSignInController), for: .touchUpInside)
    }
    
    @objc private func openSignInController() {
        if let signInViewModel = signInViewModel {
            let vc = SignInController(viewModel: signInViewModel)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func signUp() {
        contentView.signUpButton.addTarget(self, action: #selector(registerAndOpenDetails), for: .touchUpInside)
    }
    
    @objc private func registerAndOpenDetails() {
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

}
