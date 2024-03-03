//
//  PaymentMethodView.swift
//  WATT
//
//  Created by Glib Galchenko on 01/03/24.
//

import UIKit

class PaymentMethodView: UIView {
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(Asset.Icons.Navigation.chevronLeft, for: .normal)
        button.tintColor = .white
        button.imageView?.fillSuperview()
        return button
    }()
    
    let blueBackgroundView = BlueBackgroundView()
    
    let blueBackgroundHeight = UIScreen.main.bounds.height * 0.29
    
    let titleLabel = TextLabel(title: "Add payment method", font: .systemFont(ofSize: 28, weight: .bold), textColor: .white, numberOfLines: 0)
    let subtitleLable = SecondaryLabel(text: "Select your payment method", textColor: .white, numbersOfLines: 0, textAlignment: .natural)

    let anotherMethodLabel = TextFieldLabel(title: "ADD ANOTHER PAYMENT METHOD")

//    var bankProvider: PaymentMethodType?
    let paymentMethodsTableView = UITableView()
//    var tableViewHeight: CGFloat
//    var tableViewCount: Int
    let addCreditCardRow = AddDetailRow(DetailsRowType.creditCard)
    
    let completeLaterButton = MainButton(title: "Complete later", titleColor: Asset.Colors.black, backgroundColor: .white, shadowOpacity: 0.15, shRadius: 5, shColor: .black)
    
    init() {
//        self.tableViewHeight = 0
//        self.tableViewCount = 0
        super.init(frame: .zero)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        setupBlueHeader()
        setupBackButton()
        setupLabels()
        setupTableView()
        setupCompleteLeterButton()
//        setupTableView()
//        setupRowAddCreditCard()
    }
    
    private func setupBlueHeader() {
        self.addSubview(blueBackgroundView)
        blueBackgroundView.anchor(top: self.topAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, bottom: nil, size: .init(width: 0, height: blueBackgroundHeight))
        blueBackgroundView.setupGradient(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: blueBackgroundHeight))
    }
    
    private func setupBackButton() {
        blueBackgroundView.addSubview(backButton)
        backButton.anchor(top: self.safeAreaLayoutGuide.topAnchor, leading: blueBackgroundView.leadingAnchor, trailing: nil, bottom: nil, padding: .init(top: 20, left: 26, bottom: 0, right: 0), size: .init(width: 18, height: 24))
    }
    
    private func setupLabels() {
        let stack = stack(titleLabel, subtitleLable, spacing: 6)
        self.addSubview(stack)
        stack.anchor(top: backButton.bottomAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, bottom: nil, padding: .init(top: 20, left: 20, bottom: 0, right: 20))
    }
    
    func setupTableView() { //tableView cellsCount: Int) {
        paymentMethodsTableView.backgroundColor = .clear
        paymentMethodsTableView.clipsToBounds = false
        
        self.addSubview(paymentMethodsTableView)
        paymentMethodsTableView.anchor(top: subtitleLable.bottomAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, bottom: self.bottomAnchor, padding: .init(top: 20, left: 20, bottom: 0, right: 20))
    }
    
//    private func setupRowAddCreditCard() {
//        self.addSubview(addCreditCardRow)
//        addCreditCardRow.anchor(top: paymentMethodsTableView.bottomAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, bottom: nil, padding: .init(top: 0, left: 20, bottom: 0, right: 20))
//    }
    
    func setupCompleteLeterButton() {
        let stack = stack(addCreditCardRow, completeLaterButton, spacing: 20)
        
        self.addSubview(stack)
        stack.anchor(top: nil, leading: self.leadingAnchor, trailing: self.trailingAnchor, bottom: self.bottomAnchor, padding: .init(top: 0, left: 20, bottom: 50, right: 20))
        [addCreditCardRow, completeLaterButton].forEach {
            $0.anchor(top: nil, leading: stack.leadingAnchor, trailing: stack.trailingAnchor, bottom: nil)
        }
    }
    
//    private func setupAddedMethodsRows() {
//
//        var firstStack = stack()
//
//        if !addedMethods.isEmpty {
//            for method in addedMethods {
//                firstStack.addArrangedSubview(method)
//            }
//            firstStack = stack(spacing: 10)
//            self.addSubview(firstStack)
//            firstStack.anchor(top: subtitleLable.bottomAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, bottom: nil, padding: .init(top: 25, left: 20, bottom: 0, right: 20))
//            firstStack.arrangedSubviews.forEach {
//                $0.anchor(top: nil, leading: firstStack.leadingAnchor, trailing: firstStack.trailingAnchor, bottom: nil)
//            }
//        }
//
//        let secondStack = stack(anotherMethodLabel, addCreditCardRow, spacing: 10)
//        self.addSubview(secondStack)
//        secondStack.anchor(top: firstStack.bottomAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, bottom: nil, padding: .init(top: 25, left: 20, bottom: 0, right: 20))
//        secondStack.arrangedSubviews.forEach {
//            $0.anchor(top: nil, leading: secondStack.leadingAnchor, trailing: secondStack.trailingAnchor, bottom: nil)
//        }
//    }
    
}
