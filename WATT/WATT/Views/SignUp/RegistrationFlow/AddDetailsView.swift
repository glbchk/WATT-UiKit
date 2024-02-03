//
//  AddDetailsView.swift
//  WATT
//
//  Created by Stas Boiko on 30.01.2024.
//

import UIKit

class AddDetailsView: UIView {
    
    let blueBackgroundView = BlueBackgroundView()
    
    let blueBackgroundHeight = UIScreen.main.bounds.height * 0.35
    
    let logoView = LogoView()
    
    let welcomeLabel = TextLabel(title: "Welcome to Watt!", font: .systemFont(ofSize: 22, weight: .bold), textColor: .white)
    
    let subtitleLable = SecondaryLabel(text: "We need details to provide a convenient Watt app experience for you", textColor: .white, numbersOfLines: 0, textAlignment: .center)
    
    let nameEmailRow: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.setupShadow(opacity: 0.15, radius: 5, color: .black)
        
        let accountView = UIView()
        accountView.backgroundColor = Asset.Colors.grey4
        accountView.constrainWidth(40)
        accountView.constrainHeight(40)
        accountView.layer.cornerRadius = 20
        
        let accountIconView = UIImageView(image: Asset.Icons.account)
        accountIconView.constrainWidth(24)
        accountIconView.constrainHeight(24)
        accountView.addSubview(accountIconView)
        accountIconView.centerInSuperview()
        accountIconView.tintColor = Asset.Colors.grey2
        
        let label = TextLabel(title: "Add your name & email", font: .boldSystemFont(ofSize: 15), textColor: Asset.Colors.black)
        
        let rightArrow = UIImageView(image: Asset.Icons.Navigation.chevronRight)
        rightArrow.contentMode = .scaleAspectFit
        rightArrow.tintColor = Asset.Colors.grey1
        
        let stack = UIStackView(arrangedSubviews: [accountView, label, rightArrow])
        stack.axis = .horizontal
        stack.spacing = 15
        
        view.addSubview(stack)
        stack.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, padding: .allSides(15))
        
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupBlueHeader()
        setupHeaderStack()
        setupNavigationRows()
        
        blueBackgroundView.setupGradient(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: blueBackgroundHeight))
    }
    
    private func setupBlueHeader() {
        self.addSubview(blueBackgroundView)
        blueBackgroundView.anchor(top: self.topAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, bottom: nil, size: .init(width: 0, height: blueBackgroundHeight))
    }
    
    private func setupHeaderStack() {
        let labelsStack = stack(welcomeLabel, subtitleLable, spacing: 7, alignment: .center)
        
        let stack = stack(logoView, labelsStack, spacing: 15, alignment: .center)
        
        blueBackgroundView.addSubview(stack)
        
        stack.anchor(top: nil, leading: blueBackgroundView.leadingAnchor, trailing: blueBackgroundView.trailingAnchor, bottom: blueBackgroundView.bottomAnchor, padding: .init(top: 0, left: 40, bottom: 60, right: 40))
    }
    
    private func setupNavigationRows() {
        self.addSubview(nameEmailRow)
        nameEmailRow.anchor(top: subtitleLable.bottomAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, bottom: nil, padding: .init(top: 25, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 70))
    }
    
    
}
