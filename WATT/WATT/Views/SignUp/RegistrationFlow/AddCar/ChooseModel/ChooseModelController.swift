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
    private var viewModel: CarsViewModel
    
    let cellHeight: CGFloat = 60
    
    var isModelChosen = false
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
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func saveButtonPressed() {

        if isModelChosen {
            action?()
            self.navigationController?.popViewController(animated: true)
        } else {
            print("You didn't choose any model")
        }
        
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
        isModelChosen = true
        
        viewModel.selectedCarModelID = viewModel.allCarModels[indexPath.item].id ?? "No ID"
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = contentView.carModelTableView.cellForRow(at: indexPath) as! ChooseModelCell
        cell.updateState(false)
        isModelChosen = false
        
        viewModel.selectedCarModelID = ""
    }
    
}
