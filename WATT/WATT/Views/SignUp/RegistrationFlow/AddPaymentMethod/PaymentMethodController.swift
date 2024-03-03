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
    
    let cellHeight: CGFloat = 90
    
    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
//        contentView.tableViewCount = viewModel.paymentMethods.count
//        contentView.paymentMethodsTableView.reloadData()
//        contentView.tableViewHeight = CGFloat(viewModel.paymentMethods.count) * cellHeight
//        setupMethods()
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
//        contentView.setupTableView(tableView: viewModel.paymentMethods.count)
    }
    
//    override func updateViewConstraints() {
//        tableHeightConstraint.constant = tableView.contentSize.height
//        super.updateViewConstraints()
//    }
    
    private func setupTargets() {
        contentView.addCreditCardRow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCreditCardRowTap)))
        contentView.backButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
    }
    
    @objc private func handleCompleteLater() {
        viewModel.successfulRegistration()
    }
    
    @objc private func handleBackTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func handleCreditCardRowTap() {
        let vc = AddCreditCardController(viewModel: viewModel, action: {
            self.contentView.paymentMethodsTableView.reloadData()
        })
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension PaymentMethodController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.paymentMethods.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "payment_method", for: indexPath) as! PaymentMethodCell
        
        cell.methodLogoView.image = viewModel.paymentMethods[indexPath.item].provider?.icon
        cell.titleLabel.text = viewModel.paymentMethods[indexPath.item].cardName
        cell.subtitleLabel.text = viewModel.paymentMethods[indexPath.item].cardNumber
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
}
