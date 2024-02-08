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
    private var signInViewModel: SignInViewModel
    var cancellables = Set<AnyCancellable>()

    init(viewModel: SignUpViewModel, signInViewModel: SignInViewModel) {
        self.viewModel = viewModel
        self.signInViewModel = signInViewModel
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
        presentAddDetailsController()
    }
    
    private func presentSignInController() {
        contentView.signInButton.addTarget(self, action: #selector(openSignInController), for: .touchUpInside)
    }
    
    @objc private func openSignInController() {
        let vc = SignInController(viewModel: signInViewModel, signUpViewModel: viewModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func presentAddDetailsController() {
        contentView.signUpButton.addTarget(self, action: #selector(openAddDetailsController), for: .touchUpInside)
    }
    
    @objc private func openAddDetailsController() {
        let vc = AddDetailsController(viewModel: viewModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
