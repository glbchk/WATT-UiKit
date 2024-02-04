//
//  MainScreenController.swift
//  WATT
//
//  Created by Glib Galchenko on 25/12/23.
//

import UIKit
import Combine

class MainViewController: UIViewController {
    
    private lazy var contentView = MainView()
    private var viewModel: MainViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupViewConstratints()
        setupTarget()
    }
    
    private func setData() {
        viewModel.$user
            .sink { user in
                if user != nil {
                    self.contentView.nameLabel.text = user?.fullName
                    self.contentView.emailLabel.text = user?.email
                }
            }
            .store(in: &cancellables)
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
        contentView.signOutButton.addTarget(self, action: #selector(onPressButton), for: .touchUpInside)
    }
    
    @objc private func onPressButton() {
        viewModel.signOut()
    }
    
}

