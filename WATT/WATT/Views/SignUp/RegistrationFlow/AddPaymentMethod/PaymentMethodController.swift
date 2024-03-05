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
        let vc = AddCreditCardController(viewModel: paymentMethodViewModel, action: {
            self.contentView.paymentMethodsTableView.reloadData()
        })
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension PaymentMethodController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentMethodViewModel.addedPaymentMethods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "payment_method", for: indexPath) as! PaymentMethodCell
        
        cell.methodLogoView.image = paymentMethodViewModel.addedPaymentMethods[indexPath.item].provider?.icon
        cell.titleLabel.text = paymentMethodViewModel.addedPaymentMethods[indexPath.item].cardName
        cell.subtitleLabel.text = paymentMethodViewModel.addedPaymentMethods[indexPath.item].cardNumber
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = EditCreditCardController(viewModel: paymentMethodViewModel, action: {
            self.contentView.paymentMethodsTableView.reloadData()
        })
        
        vc.contentView.cardNameTextField.text = viewModel.paymentMethodViewModel?.addedPaymentMethods[indexPath.row].cardName
        vc.contentView.cardNumberTextField.text = viewModel.paymentMethodViewModel?.addedPaymentMethods[indexPath.row].cardNumber
        vc.contentView.expiryTextField.text = viewModel.paymentMethodViewModel?.addedPaymentMethods[indexPath.row].expiryDate
        vc.contentView.cvvTextField.text = viewModel.paymentMethodViewModel?.addedPaymentMethods[indexPath.row].cvv
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
