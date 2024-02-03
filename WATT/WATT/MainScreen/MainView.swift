//
//  MainView.swift
//  WATT
//
//  Created by Glib Galchenko on 29/01/24.
//

import UIKit

final class MainView: UIView {

    lazy var nameLabel = UILabel()
    lazy var emailLabel = UILabel()
    lazy var signOutButton = UIButton()
    
    init() {
        super.init(frame: .zero)
        
        setupConstraints()
        setupUIComponents()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        self.addSubview(nameLabel)
        self.addSubview(emailLabel)
        self.addSubview(signOutButton)
        
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            signOutButton.topAnchor.constraint(equalToSystemSpacingBelow: emailLabel.bottomAnchor, multiplier: 20)
        ])
    }
    
    private func setupUIComponents() {
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "Here should be your NAME"
        nameLabel.textColor = UIColor.black
        
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.text = "Here should be your EMAIL"
        emailLabel.textColor = UIColor.black
        
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        signOutButton.backgroundColor = UIColor.blue
        signOutButton.setTitle("Sign Out", for: .normal)
        signOutButton.setTitleColor(.white, for: .normal)
        signOutButton.layer.cornerRadius = 10
        signOutButton.layer.masksToBounds = true
    }

}
