//
//  ChooseModelController.swift
//  WATT
//
//  Created by Glib Galchenko on 03/03/24.
//

import UIKit
import Combine

class ChooseModelController: UIViewController {
    
    let contentView = ChooseModelView()
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
        
        setupTargets()
        bindViewsToViewModel()
        bindCvvFieldPublisher()
        
        contentView.carModelTableView.dataSource = self
        contentView.carModelTableView.delegate = self
        contentView.carModelTableView.register(UITableViewCell.self, forCellReuseIdentifier: "model1")
    }
    
    private func setupTargets() {
        contentView.backButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
        contentView.saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
    }
    
    @objc private func handleBackTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func saveButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func bindViewsToViewModel() {
//        contentView.cardNameTextField.textPublisher
//            .receive(on: DispatchQueue.main)
//            .assign(to: \.cardName, on: viewModel)
//            .store(in: &cancellables)
//
//        contentView.cardNumberTextField.textPublisher
//            .receive(on: DispatchQueue.main)
//            .assign(to: \.cardNumber, on: viewModel)
//            .store(in: &cancellables)
//
//        contentView.expiryTextField.textPublisher
//            .receive(on: DispatchQueue.main)
//            .assign(to: \.expiry, on: viewModel)
//            .store(in: &cancellables)
//
//        contentView.cvvTextField.textPublisher
//            .receive(on: DispatchQueue.main)
//            .assign(to: \.cvv, on: viewModel)
//            .store(in: &cancellables)
//
//        contentView.toggle.toggleStatePublisher?
//            .receive(on: DispatchQueue.main)
//            .assign(to: \.defaultPaymentMethod, on: viewModel)
//            .store(in: &cancellables)
    }
    
    private func bindCvvFieldPublisher() {
//        contentView.cvvTextFieldView.secureFieldPublisher = viewModel.cvvPublisher
//        contentView.cvvTextFieldView.action = { self.viewModel.showCvv.toggle() }
    }
    
}

extension ChooseModelController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.fakeDataTable.count
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 60
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "model1", for: indexPath)
        
        cell.textLabel?.text = viewModel.fakeDataTable[indexPath.item]
        
        return cell
    }
    
}
