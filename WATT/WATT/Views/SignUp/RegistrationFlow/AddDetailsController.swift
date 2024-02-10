//
//  AddDetailsController.swift
//  WATT
//
//  Created by Stas Boiko on 30.01.2024.
//

import UIKit
import Combine

class AddDetailsController: UIViewController {
    
    let contentView = AddDetailsView()
    private var viewModel: SignUpViewModel
    private var mainViewModel: MainViewModel?
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
        
        contentView.nameEmailRow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleNameRowTap)))
    }
    
    private func setupTarget() {
        contentView.completeLaterButton.addTarget(self, action: #selector(handleCompleteLater), for: .touchUpInside)
    }
    
    @objc private func handleCompleteLater() {
        viewModel.successfulRegistration()
    }
    
    @objc private func handleNameRowTap() {
        let vc = AddNameAndEmailController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
