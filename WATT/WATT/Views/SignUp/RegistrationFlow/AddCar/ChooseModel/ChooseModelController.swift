//
//  ChooseModelController.swift
//  WATT
//
//  Created by Glib Galchenko on 03/03/24.
//

import UIKit
import Combine

class ChooseModelController: UIViewController {
    var cancellables = Set<AnyCancellable>()
    
    let contentView = ChooseModelView()
    let addCarNameView = AddCarNameView()
    private var viewModel: CarsViewModel
    
    let cellHeight: CGFloat = 60
    
    var isCarNamed = false
    
    var isAlertShown = false
    
    let action: (() -> Void)?
    
    init(viewModel: CarsViewModel, action: (() -> Void)?) {
        self.viewModel = viewModel
        self.action = action
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.loadCarModels {
            self.contentView.carModelTableView.reloadData()
        }
        
        view.addSubview(contentView)
        contentView.fillSuperview()
        bindViewToVieModel()
        
        setupTargets()
        
        contentView.carModelTableView.dataSource = self
        contentView.carModelTableView.delegate = self
        contentView.carModelTableView.register(ChooseModelCell.self, forCellReuseIdentifier: Identifiers.TableCell.modelCell)
        
        contentView.titleLabel.text = viewModel.selectedBrandName
    }
    
    private func setupTargets() {
        contentView.backButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
        addCarNameView.saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
    }
    
    @objc private func handleBackTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func saveButtonPressed() {
        
        switch isCarNamed {
            case true:
                action?()
                
                self.navigationController?.popViewController(animated: true)
                dismiss(animated: true)
                isAlertShown = false
            case false:
                if viewModel.carName.isEmpty {
                    addCarNameView.carErrorNameLabel.text = TFError.AddCar.carNameIsAlreadyUsed.description
                    addCarNameView.carErrorNameLabel.isHidden = false
                }
            
                self.view.endEditing(true)
//            shakeAnimation(of: contentView.signUpButton)
        }
        
    }
    
    @objc private func showTextFieldAndButton() {
        let vc = SlideUpPanelController(contentView: addCarNameView, height: UIScreen.main.bounds.height / 3.5)
        
        isAlertShown = true
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        navigationController?.present(vc, animated: true)
    }
    
    private func bindViewToVieModel() {
            
        addCarNameView.carNameTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.carName, on: viewModel)
            .store(in: &cancellables)
        
        viewModel.isCarNameAddedPublisher
            .sink { [weak self] result in
                guard let self = self else { return }
                switch result {
                    case .success:
                        addCarNameView.carErrorNameLabel.isHidden = true
                        addCarNameView.saveButton.backgroundColor = Asset.Colors.deepBlue
                        addCarNameView.saveButton.isEnabled = true
                    
                        isCarNamed = true
                    case .failure(let failure):
                        addCarNameView.carErrorNameLabel.text = failure.description
                        addCarNameView.carErrorNameLabel.isHidden = false
                        addCarNameView.saveButton.backgroundColor = Asset.Colors.grey1
                        addCarNameView.saveButton.isEnabled = false
                    
                        isCarNamed = false
                    }
            }
            .store(in: &cancellables)
        
    }
    
}

extension ChooseModelController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.allCarModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.separatorStyle = .singleLine
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.TableCell.modelCell, for: indexPath) as! ChooseModelCell
        cell.selectionStyle = .none
        
        cell.titleLabel.text = viewModel.allCarModels[indexPath.item].carModel
        cell.subTitleLabel.text = viewModel.allCarModels[indexPath.item].carVersion
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = contentView.carModelTableView.cellForRow(at: indexPath) as! ChooseModelCell
        cell.updateState(true)
        showTextFieldAndButton()
        
        viewModel.selectedCarModelID = viewModel.allCarModels[indexPath.item].id ?? "No ID"
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = contentView.carModelTableView.cellForRow(at: indexPath) as! ChooseModelCell
        cell.updateState(false)
        
        viewModel.selectedCarModelID = ""
    }
    
}
