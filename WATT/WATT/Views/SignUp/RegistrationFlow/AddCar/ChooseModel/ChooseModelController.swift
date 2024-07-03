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
    let errorAddedCarView = ErrorAddedCarView()
    private var viewModel: CarsViewModel
    
    let cellHeight: CGFloat = 60
    
//    var isModelChosen = false
    
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
        contentView.saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
    }
    
    @objc private func handleBackTap() {
        viewModel.isModelChosen = false
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func saveButtonPressed() {
        
        let isCarAdded = viewModel.isCarAdded(carId: viewModel.selectedCar.id ?? "")
        
        if !isCarAdded {
            action?()
            
            viewModel.isModelChosen = false
            self.navigationController?.popViewController(animated: true)
        } else {
            showAlertIsCarDuplicated()
        }
 
    }
    
    @objc private func showAlertIsCarDuplicated() {
        let vc = AlertController(contentView: errorAddedCarView, buttonTitle: "Understood", height: UIScreen.main.bounds.height / 3) {
            print("Ok!")
            self.dismiss(animated: true)
            if self.viewModel.allCarModels.count == 1 {
                self.navigationController?.popViewController(animated: true)
            }
            self.isAlertShown = false
        } completionClose: {
            self.isAlertShown = false
        }
        
        isAlertShown = true
        vc.closeButton.isHidden = true
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        navigationController?.present(vc, animated: true)
    }
    
    private func bindViewToVieModel() {
        viewModel.isModelChosenPublisher
            .sink { [weak self] isModelChosen in
                guard let self = self else { return }
                
                if isModelChosen {
                    contentView.saveButton.backgroundColor = Asset.Colors.deepBlue
                    contentView.saveButton.isEnabled = true
                } else {
                    contentView.saveButton.backgroundColor = Asset.Colors.grey1
                    contentView.saveButton.isEnabled = false
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
        viewModel.isModelChosen = true
        
        viewModel.selectedCarModelID = viewModel.allCarModels[indexPath.item].id ?? "No ID"
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = contentView.carModelTableView.cellForRow(at: indexPath) as! ChooseModelCell
        cell.updateState(false)
        viewModel.isModelChosen = false
        
        viewModel.selectedCarModelID = ""
    }
    
}
