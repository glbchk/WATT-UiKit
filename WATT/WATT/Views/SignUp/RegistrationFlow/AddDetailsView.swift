//
//  AddDetailsView.swift
//  WATT
//
//  Created by Stas Boiko on 30.01.2024.
//

import UIKit
import Combine

class AddDetailsView: UIView {
    
    // should be placed in viewModel like user publisher
    @Published var nameExist = false
    @Published var carExist = false
    @Published var cardExist = false
    
    private var namePublisher: AnyPublisher<Bool, Never> {
        $nameExist
            .eraseToAnyPublisher()
    }
    
    private var carPublisher: AnyPublisher<Bool, Never> {
        $carExist
            .eraseToAnyPublisher()
    }
    
    private var cardPublisher: AnyPublisher<Bool, Never> {
        $cardExist
            .eraseToAnyPublisher()
    }
    
    let blueBackgroundView = BlueBackgroundView()
    
    let blueBackgroundHeight = UIScreen.main.bounds.height * 0.35
    
    let logoView = LogoView()
    
    let welcomeLabel = TextLabel(title: "Welcome to Watt!", font: .systemFont(ofSize: 22, weight: .bold), textColor: .white)
    
    let subtitleLable = SecondaryLabel(text: "We need details to provide a convenient Watt app experience for you", textColor: .white, numbersOfLines: 0, textAlignment: .center)

    let completeLaterButtont = MainButton(title: "Complete later", titleColor: Asset.Colors.black, backgroundColor: .white, shadowOpacity: 0.15, shRadius: 5, shColor: .black)
    
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
        setupCompleteLeterButton()
        
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
        
        let nameEmailRow = AddDetailRow(.nameAndEmail, publisher: namePublisher)
        let carRow = AddDetailRow(.car, publisher: carPublisher)
        let paymentMethodRow = AddDetailRow(.paymentMethod, publisher: cardPublisher)
        
        let stack = stack(nameEmailRow, carRow, paymentMethodRow, spacing: 10)
        self.addSubview(stack)
        stack.anchor(top: subtitleLable.bottomAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, bottom: nil, padding: .init(top: 25, left: 20, bottom: 0, right: 20))
        stack.arrangedSubviews.forEach {
            $0.anchor(top: nil, leading: stack.leadingAnchor, trailing: stack.trailingAnchor, bottom: nil)
        }
        
        nameEmailRow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleNameRowTap)))
    }
    
    private func setupCompleteLeterButton() {
        self.addSubview(completeLaterButtont)
        completeLaterButtont.anchor(top: nil, leading: self.leadingAnchor, trailing: self.trailingAnchor, bottom: self.bottomAnchor, padding: .init(top: 0, left: 20, bottom: 50, right: 20))
    }
    
    @objc private func handleNameRowTap() {
        nameExist.toggle()
    }
    
    
}
