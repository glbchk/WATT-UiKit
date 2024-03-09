//
//  AddDetailsController.swift
//  WATT
//
//  Created by Stas Boiko on 30.01.2024.
//

import UIKit
import Combine

class AddDetailsController: UIViewController {
    var cancellables = Set<AnyCancellable>()
    
    let contentView = AddDetailsView()
    private var viewModel: SignUpViewModel

    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(contentView)
        contentView.fillSuperview()
        setupTarget()
        bindViewModel()
    }
    
    private func setupTarget() {
        contentView.carRow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleAddCarRowTap)))
        contentView.paymentMethodRow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleAddPaymentRowTap)))
        contentView.nameAndPhoneNumberRow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleNameRowTap)))
        contentView.completeLaterButton.addTarget(self, action: #selector(completeLaterPressed), for: .touchUpInside)
    }
    
    @objc private func completeLaterPressed() {
        viewModel.successfulRegistration()
    }
    
    @objc private func handleAddCarRowTap() {
        let vc = AddCarController(viewModel: viewModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func handleAddPaymentRowTap() {
        guard let paymentMethodViewModel = viewModel.paymentMethodViewModel else { return }
        let vc = PaymentMethodController(viewModel: viewModel, paymentMethodViewModel: paymentMethodViewModel, action: {
            paymentMethodViewModel.selectedPaymentMethod?.cardNumber = String(paymentMethodViewModel.selectedPaymentMethod?.cardNumber.filter(Set("1234567890").contains) ?? "")
            
            if let selectedPaymentMethod = paymentMethodViewModel.selectedPaymentMethod {
                self.viewModel.paymentMethods.append(selectedPaymentMethod)
            }
        })
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func handleNameRowTap() {
        let vc = AddNameAndPhoneNumberController(viewModel: viewModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func bindViewModel() {
        //add here car and payment method publishers
        contentView.paymentMethodRow.publisher = viewModel.paymentMethodViewModel?.createPaymentMethodPublisher(methods: viewModel.paymentMethods)
        contentView.nameAndPhoneNumberRow.publisher = viewModel.createNameAndPhoneNumberPublisher()
    }
    
}
