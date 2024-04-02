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
        
        paymentMethodViewModel.cardName = ""
        paymentMethodViewModel.cardNumber = ""
        paymentMethodViewModel.expiry = ""
        paymentMethodViewModel.cvv = ""
        
        let vc = AddAndEditPMController(viewModel: paymentMethodViewModel, toggleAction: { [self] in
            paymentMethodViewModel.defaultMethodToggle()
            viewModel.paymentMethods = paymentMethodViewModel.addedPaymentMethods
            
            contentView.paymentMethodsTableView.reloadData()
        }, saveAction: { [self] in
            paymentMethodViewModel.savePaymentMethod()
            viewModel.paymentMethods = paymentMethodViewModel.addedPaymentMethods
            
            contentView.paymentMethodsTableView.reloadData()
        })
        
        vc.contentView.deleteButton.isHidden = true
        
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
        return paymentMethodViewModel.addedPaymentMethods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "payment_method", for: indexPath) as! PaymentMethodCell
        
        cell.selectionStyle = .none
        cell.methodLogoView.image = paymentMethodViewModel.addedPaymentMethods[indexPath.item].provider?.icon
        cell.titleLabel.text = paymentMethodViewModel.addedPaymentMethods[indexPath.item].cardName
        cell.subtitleLabel.text = hideCardNumbers(card: paymentMethodViewModel.addedPaymentMethods[indexPath.item].cardNumber)
        if paymentMethodViewModel.addedPaymentMethods[indexPath.item].isDefault == true {
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
        
        let vc = AddAndEditPMController(viewModel: paymentMethodViewModel, toggleAction: { [self] in
            paymentMethodViewModel.editPaymentMethod()
            viewModel.paymentMethods = paymentMethodViewModel.addedPaymentMethods
            
            contentView.paymentMethodsTableView.reloadData()
        }, saveAction: { [self] in
            
            paymentMethodViewModel.editPaymentMethod()
            viewModel.paymentMethods = paymentMethodViewModel.addedPaymentMethods
            
            contentView.paymentMethodsTableView.reloadData()
        }, deleteAction: { [self] in
            paymentMethodViewModel.deletePaymentMethod()
            viewModel.paymentMethods = paymentMethodViewModel.addedPaymentMethods
            
            contentView.paymentMethodsTableView.reloadData()
        })
        
        let selectedIndex = paymentMethodViewModel.addedPaymentMethods[indexPath.item]
        
        paymentMethodViewModel.selectedPaymentMethod = selectedIndex
        
        vc.contentView.cardNameTextField.text = selectedIndex.cardName
        vc.contentView.cardNumberTextField.text = selectedIndex.cardNumber
        vc.contentView.expiryTextField.text = selectedIndex.expiryDate
        vc.contentView.cvvTextField.text = selectedIndex.cvv
        vc.contentView.toggle.isOn = selectedIndex.isDefault
        
        vc.contentView.cardNumberTextField.isEnabled = false
        vc.contentView.cardNumberTextFieldView.backgroundColor = Asset.Colors.grey3
        vc.contentView.cardNumberTextFieldView.textField?.textColor = Asset.Colors.darkGrey
        vc.contentView.expiryTextFieldView.textField?.isEnabled = false
        vc.contentView.expiryTextFieldView.backgroundColor = Asset.Colors.grey3
        vc.contentView.expiryTextFieldView.textField?.textColor = Asset.Colors.darkGrey
        
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


