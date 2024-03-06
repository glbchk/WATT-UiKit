//
//  AddDetailsController.swift
//  WATT
//
//  Created by Stas Boiko on 30.01.2024.
//

import UIKit
import Combine

class AddDetailsController: BaseViewController {
    
    let contentView = AddDetailsView()
    private var viewModel: SignUpViewModel
    var cancellables = Set<AnyCancellable>()

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
        
        contentView.nameAndPhoneNumberRow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleNameRowTap)))
    }
    
    private func setupTarget() {
        contentView.completeLaterButton.addTarget(self, action: #selector(completeLaterPressed), for: .touchUpInside)
    }
    
    @objc private func completeLaterPressed() {
        viewModel.successfulRegistration()
    }
    
    @objc private func handleNameRowTap() {
        let vc = AddNameAndPhoneNumberController(viewModel: viewModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func bindViewModel() {
        //add here car and payment method publishers
        contentView.nameAndPhoneNumberRow.publisher = viewModel.createNameAndPhoneNumberPublisher()
    }
    
}
