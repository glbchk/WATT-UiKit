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

    let paymentMethodsTableView = UITableView()
    let addCreditCardRow = AddCreditCardRow()
    
    let continueButton = MainButton(title: "Continue")
    
    init() {
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
        setupButtons()
        setupTableView()
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
    
    func setupTableView() {
        paymentMethodsTableView.backgroundColor = .clear
        paymentMethodsTableView.clipsToBounds = true
        
        self.addSubview(paymentMethodsTableView)
        paymentMethodsTableView.anchor(top: subtitleLable.bottomAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, bottom: addCreditCardRow.topAnchor, padding: .init(top: 20, left: 20, bottom: 0, right: 20))
    }
    
    func setupButtons() {
        let stack = stack(addCreditCardRow, continueButton, spacing: 20)
        
        self.addSubview(stack)
        stack.anchor(top: nil, leading: self.leadingAnchor, trailing: self.trailingAnchor, bottom: self.bottomAnchor, padding: .init(top: 0, left: 20, bottom: 50, right: 20))
        [addCreditCardRow, continueButton].forEach {
            $0.anchor(top: nil, leading: stack.leadingAnchor, trailing: stack.trailingAnchor, bottom: nil)
        }
    }
    
}


class AddCreditCardRow: UIView {
    
    let rowView: UIView = {
        let view = UIView()
        view.constrainWidth(60)
        view.constrainHeight(60)
        view.backgroundColor = Asset.Colors.grey4
        view.layer.cornerRadius = 5
        return view
    }()
    
    let rowImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.constrainWidth(30)
        imgView.constrainHeight(30)
        imgView.tintColor = Asset.Colors.deepBlue
        return imgView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = Asset.Colors.black
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    let detailsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = Asset.Colors.grey1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    let rightArrow: UIImageView = {
        let view = UIImageView(image: Asset.Icons.Navigation.chevronRight)
        view.contentMode = .scaleAspectFit
        view.tintColor = Asset.Colors.grey1
        view.constrainWidth(24)
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 15
        self.setupShadow(opacity: 0.15, radius: 5, color: .black)
        
        self.constrainHeight(90)
        
        rowImageView.image = Asset.Icons.card
        rowImageView.image?.withRenderingMode(.alwaysTemplate)
        rowImageView.tintColor = Asset.Colors.deepBlue
        
        label.text = "Add credit card"
        
        rowView.addSubview(rowImageView)
        rowImageView.centerInSuperview()
        
        let labelsStack = stack(label, detailsLabel, spacing: 3)
        
        let stack = hstack(rowView, labelsStack, rightArrow, spacing: 15)
        
        self.addSubview(stack)
        stack.anchor(top: self.topAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, bottom: self.bottomAnchor, padding: .allSides(15))
    }
    
}
