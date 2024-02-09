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
        
        contentView.completeLaterButtont.addTarget(self, action: #selector(onPressButton), for: .touchUpInside)
    }
    
    @objc private func handleCompleteLater() {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func onPressButton() {
        if let mainViewModel = mainViewModel {
            let vc = MainViewController(viewModel: mainViewModel)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
//    @objc private func onPressButton() {
//        viewModel.createUser { isActive, error in
//            DispatchQueue.main.async {
//                self.contentView.completeLaterButtont.isEnabled = isActive
//                self.viewModel.successfulRegistration()
////                if !error.isEmpty {
////                    self.contentView.errorLabel.alpha = 1
////                    self.contentView.errorLabel.text = error
////                }
//            }
//        }
//    }
    
}
