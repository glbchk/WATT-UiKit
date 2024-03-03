//
//  ProfileViewController.swift
//  WATT
//
//  Created by Glib Galchenko on 01/03/24.
//

import UIKit
import Combine

class ProfileViewController: UIViewController {
    var cancellables = Set<AnyCancellable>()
    
    let contentView = ProfileView()
    private var viewModel: SettingsViewModel
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupUserData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(contentView)
        contentView.fillSuperview()
        
        setupTargets()
    }
    
    private func setupTargets() {
        contentView.backButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
        contentView.changePasswordButton.addTarget(self, action: #selector(changePasswordButtonPressed), for: .touchUpInside)
    }
    
    @objc private func handleBackTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func changePasswordButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupUserData() {
        viewModel.$user
            .sink { user in
                if user != nil {
                    self.contentView.nameRow.detailsLabel.text = user?.fullName ?? "Name is not added"
                    self.contentView.emailRow.detailsLabel.text = user?.email
                    self.contentView.phoneNumberRow.detailsLabel.text = user?.phoneNumber ?? "Phone number is not added"
                    self.contentView.languageRow.detailsLabel.text = "English" //viewModel.user?.language
                }
            }
            .store(in: &cancellables)
    }
    
}
