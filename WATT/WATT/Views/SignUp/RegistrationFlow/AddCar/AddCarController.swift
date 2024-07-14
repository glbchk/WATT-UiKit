//
//  AddCarController.swift
//  WATT
//
//  Created by Glib Galchenko on 03/03/24.
//

import UIKit
import Combine

enum Sections {
    case addedCars
    case allBrands
}
    
class AddCarController: UIViewController {
    var cancellables = Set<AnyCancellable>()
    
    let contentView = AddCarView()
    private var viewModel: CarsViewModel
    
    private var sections: [Sections] = [.allBrands]
    
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
        bindToViewModel()
        
        if !viewModel.cars.isEmpty && sections.count == 1 {
            sections.insert(.addedCars, at: 0)
        }
        if viewModel.cars.isEmpty {
            contentView.carsCollectionView.showLoading()
        }
            
        viewModel.loadBrands {
            self.contentView.carsCollectionView.stopLoading()
            self.contentView.carsCollectionView.reloadData()
        }
        
        view.addSubview(contentView)
        contentView.fillSuperview()

        contentView.carsCollectionView.delegate = self
        contentView.carsCollectionView.dataSource = self
        contentView.carsCollectionView.register(CarBrandCell.self, forCellWithReuseIdentifier: Identifiers.CollectionCell.carCell)
        contentView.carsCollectionView.register(CarBrandHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Identifiers.CollectionCell.header)
        contentView.carsCollectionView.register(EmptyHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Identifiers.CollectionCell.emptyHeader)
        
        setupTarget()
    }
    
    private func setupTarget() {
        contentView.backButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
        contentView.saveCarsButton.addTarget(self, action: #selector(saveCarsPressed), for: .touchUpInside)
    }
    
    @objc private func handleBackTap() {
        action?()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func saveCarsPressed() {
        action?()
        self.navigationController?.popViewController(animated: true)
    }
    
    func bindToViewModel() {
        viewModel.$cars
            .sink { [weak self] cars in
                guard let self = self else { return }
                if cars.isEmpty {
                    contentView.bgSaveCarButton.isHidden = true
//                    contentView.carsCollectionStackBottomSize = 0
                } else if viewModel.cars.isEmpty {
                    contentView.bgSaveCarButton.isHidden = false
//                    contentView.carsCollectionStackBottomSize = 250
                }
            }
            .store(in: &cancellables)
    }
    
}

extension AddCarController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch self.sections[section] {
        case .addedCars:
            return self.viewModel.cars.count
        case .allBrands:
            return self.viewModel.allCarBrands.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 40, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch sections[indexPath.section] {
            case .addedCars:
                return addedCarsViewCell(collectionView, cellForItemAt: indexPath)
            case .allBrands:
                return allBrandsViewCell(collectionView, cellForItemAt: indexPath)
        }
    }
    
    func addedCarsViewCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.CollectionCell.carCell, for: indexPath) as? CarBrandCell else { return CarBrandCell() }
        
        cell.titleLabel.text = "\(viewModel.cars[indexPath.item].brandName ?? ""), \(viewModel.cars[indexPath.item].carModel ?? "")"
        cell.topLabel.isHidden = false
        cell.topLabel.text = "\(viewModel.cars[indexPath.item].carName ?? "")"
        cell.subtitleLabel.isHidden = false
        cell.subtitleLabel.text = "Connected"
        cell.squareImageView?.loadFrom(URLAddress: viewModel.cars[indexPath.item].brandThumbnailLogoURL ?? "")
        
        return cell
    }
    
    func allBrandsViewCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.CollectionCell.carCell, for: indexPath) as? CarBrandCell else { return CarBrandCell() }
        
        cell.titleLabel.text = viewModel.allCarBrands[indexPath.item].brandName
        cell.squareImageView?.loadFrom(URLAddress: viewModel.allCarBrands[indexPath.item].brandThumbnailLogoURL ?? "")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            if sections[indexPath.section] == .allBrands && !viewModel.cars.isEmpty {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Identifiers.CollectionCell.header, for: indexPath) as! CarBrandHeader
                
                return headerView
            }
        }
        
        let emptyView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Identifiers.CollectionCell.emptyHeader, for: indexPath) as! EmptyHeader
        return emptyView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if sections[section] == .allBrands && !viewModel.cars.isEmpty {
            return CGSize(width: collectionView.bounds.width, height: 40)
        } else {
            return CGSize(width: collectionView.bounds.width, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch sections[indexPath.section] {
            case .addedCars:
            let vc = CarDetailsController(viewModel: viewModel, deleteAction: { [weak self] in
                guard let self = self else { return }
                
                self.viewModel.deleteCars(carID: self.viewModel.cars[indexPath.item].id ?? "")
                
                if self.viewModel.cars.isEmpty {
                    self.sections.remove(at: 0)
                }
                
                self.contentView.carsCollectionView.reloadData()
            })
            
            vc.selectedAddedCarID = indexPath.item
                
            self.navigationController?.pushViewController(vc, animated: true)
                
            case .allBrands:
                let vc = ChooseModelController(viewModel: viewModel, action: {
                    
                    self.viewModel.loadCarDetails { [self] in
                        
                        viewModel.selectedCar?.carName = viewModel.carName
                        guard let selectedCar = viewModel.selectedCar else { return }
                        viewModel.cars.insert(selectedCar, at: 0)
                        
                        if viewModel.cars.count >= 1 && sections.count == 1 {
                            sections.insert(.addedCars, at: 0)
                        }
                        viewModel.selectedCar = nil
                        viewModel.carName = ""
                        
                        contentView.carsCollectionView.reloadData()
                    }
                    
                })
            
                viewModel.selectedBrandName = viewModel.allCarBrands[indexPath.item].brandName ?? "No name"
                
                self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}


extension UIImageView {
    func loadFrom(URLAddress: String) {
        if let url = URL(string: URLAddress) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    print(error.localizedDescription)
                    return
                }
            }
            
            guard let imageData = data else { return }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: imageData)
            }
        }
        .resume()
    }
        
        
    }
}


extension UIView {
    static let loadingViewTag = 1938123987
    func showLoading(style: UIActivityIndicatorView.Style = .medium) {
        var loading = viewWithTag(UIImageView.loadingViewTag) as? UIActivityIndicatorView
        if loading == nil {
            loading = UIActivityIndicatorView(style: style)
        }
        
        loading?.translatesAutoresizingMaskIntoConstraints = false
        loading!.startAnimating()
        loading!.hidesWhenStopped = true
        loading?.tag = UIView.loadingViewTag
        addSubview(loading!)
        loading?.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        loading?.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }

    func stopLoading() {
        let loading = viewWithTag(UIView.loadingViewTag) as? UIActivityIndicatorView
        loading?.stopAnimating()
        loading?.removeFromSuperview()
    }
}

