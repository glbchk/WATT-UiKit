//
//  PaymentMethodController.swift
//  WATT
//
//  Created by Glib Galchenko on 01/03/24.
//

import UIKit
import Combine

class PaymentMethodController: UIViewController {
    var cancellables = Set<AnyCancellable>()
    
    let contentView = PaymentMethodView()
    private var viewModel: SignUpViewModel
    private var paymentMethodViewModel: PaymentMethodViewModel
    
    let cellHeight: CGFloat = 100
    
    let action: (() -> Void)?
    
    init(viewModel: SignUpViewModel, paymentMethodViewModel: PaymentMethodViewModel, action: (() -> Void)?) {
        self.viewModel = viewModel
        self.paymentMethodViewModel = paymentMethodViewModel
        self.action = action
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(contentView)
        contentView.fillSuperview()
        
        setupTargets()
        
        contentView.paymentMethodsTableView.dataSource = self
        contentView.paymentMethodsTableView.delegate = self
        contentView.paymentMethodsTableView.register(PaymentMethodCell.self, forCellReuseIdentifier: "payment_method")
        contentView.paymentMethodsTableView.separatorStyle = .none

    }
    
    private func setupTargets() {
        contentView.continueButton.addTarget(self, action: #selector(handleContinueButton), for: .touchUpInside)
        contentView.addCreditCardRow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCreditCardRowTap)))
        contentView.backButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
    }
    
    @objc private func handleContinueButton() {
        action?()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func handleBackTap() {
        action?()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func handleCreditCardRowTap() {
        let vc = AddCreditCardController(viewModel: paymentMethodViewModel, toggleAction: { [self] in
            paymentMethodViewModel.defaultMethodToggle()
            viewModel.paymentMethods = paymentMethodViewModel.addedPaymentMethods
            
            contentView.paymentMethodsTableView.reloadData()
        }, saveAction: { [self] in
            paymentMethodViewModel.savePaymentMethod()
            paymentMethodViewModel.cardName = ""
            paymentMethodViewModel.cardNumber = ""
            paymentMethodViewModel.expiry = ""
            paymentMethodViewModel.cvv = ""
            
            viewModel.paymentMethods = paymentMethodViewModel.addedPaymentMethods
            
            contentView.paymentMethodsTableView.reloadData()
        })
        if viewModel.paymentMethods.isEmpty {
            vc.contentView.toggle.isOn = true
            paymentMethodViewModel.defaultPaymentMethod = vc.contentView.toggle.isOn
        } else {
            vc.contentView.toggle.isOn = false
            paymentMethodViewModel.defaultPaymentMethod = vc.contentView.toggle.isOn
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension PaymentMethodController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.paymentMethods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "payment_method", for: indexPath) as! PaymentMethodCell
        
        cell.selectionStyle = .none
        cell.methodLogoView.image = viewModel.paymentMethods[indexPath.item].provider?.icon
        cell.titleLabel.text = viewModel.paymentMethods[indexPath.item].cardName
        cell.subtitleLabel.text = hideCardNumbers(card: viewModel.paymentMethods[indexPath.item].cardNumber)
        if viewModel.paymentMethods[indexPath.item].isDefault == true {
            cell.defaultMethodLabel.isHidden = false
        } else {
            cell.defaultMethodLabel.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = EditCreditCardController(viewModel: paymentMethodViewModel, editAction: { [self] in
            paymentMethodViewModel.editPaymentMethod()
            viewModel.paymentMethods = paymentMethodViewModel.addedPaymentMethods
            
            contentView.paymentMethodsTableView.reloadData()
        }, toggleAction: { [self] in
            paymentMethodViewModel.defaultMethodToggle()
            viewModel.paymentMethods = paymentMethodViewModel.addedPaymentMethods
            
            contentView.paymentMethodsTableView.reloadData()
        }, deleteAction: { [self] in
            paymentMethodViewModel.deletePaymentMethod()
            viewModel.paymentMethods = paymentMethodViewModel.addedPaymentMethods
            
            contentView.paymentMethodsTableView.reloadData()
        })
        
        let selectedIndex = viewModel.paymentMethods[indexPath.item]
        
        paymentMethodViewModel.selectedPaymentMethod = selectedIndex
        
        vc.contentView.cardNameTextField.text = selectedIndex.cardName
        vc.contentView.cardNumberTextField.text = selectedIndex.cardNumber //paymentMethodViewModel.formatTextWithSpaces(text: selectedIndex.cardNumber)
        vc.contentView.expiryTextField.text = selectedIndex.expiryDate
        vc.contentView.cvvTextField.text = selectedIndex.cvv
        vc.contentView.toggle.isOn = selectedIndex.isDefault
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func hideCardNumbers(card number: String) -> String {
        var result = ""
        
        let firstTwoDigits = number.prefix(2)
        let lastFourDigits = number.suffix(4)
        result = "\(firstTwoDigits)****\(lastFourDigits)"
        
        return result
    }
    
}


