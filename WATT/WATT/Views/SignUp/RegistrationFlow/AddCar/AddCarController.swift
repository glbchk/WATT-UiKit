//
//  AddCarController.swift
//  WATT
//
//  Created by Glib Galchenko on 03/03/24.
//

import UIKit
import Combine

class AddCarController: UIViewController {
    var cancellables = Set<AnyCancellable>()
    
    let contentView = AddCarView()
    private var viewModel: CarsViewModel
    
    init(viewModel: CarsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        viewModel.loadCarBrands()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.carBrandsCollectionView.showLoading()
        
        viewModel.loadCarBrands {
            self.contentView.carBrandsCollectionView.stopLoading()
            self.contentView.carBrandsCollectionView.reloadData()
        }
        
        view.addSubview(contentView)
        contentView.fillSuperview()

        contentView.carBrandsCollectionView.delegate = self
        contentView.carBrandsCollectionView.dataSource = self
        contentView.carBrandsCollectionView.register(CarBrandCell.self, forCellWithReuseIdentifier: Identifiers.CollectionCell.carCell)
//        contentView.carsCollectionView.reloadData()
        
        setupTarget()
    }
    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//        self.contentView.carsView.layoutIfNeeded()
//    }
    
    private func setupTarget() {
        contentView.backButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
        contentView.completeLaterButton.addTarget(self, action: #selector(handleCompleteLater), for: .touchUpInside)
    }
    
    @objc private func handleCompleteLater() {
        let vc = ChooseModelController(viewModel: viewModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func handleBackTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
//    @objc private func handleRowTap() {
//        let vc = PaymentMethodController(viewModel: viewModel)
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    
}

extension AddCarController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.allCarBrands.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 40, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "car1", for: indexPath)
//        cell.backgroundColor = UIColor(.black)
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.CollectionCell.carCell, for: indexPath) as? CarBrandCell else { return CarBrandCell() }
//        cell.titleLabel.text = viewModel.fakeDataCollection[indexPath.item].title
//        cell.squareImageView?.image = viewModel.fakeDataCollection[indexPath.item].image.image
        
        cell.titleLabel.text = viewModel.allCarBrands[indexPath.item].brandName
        cell.squareImageView?.loadFrom(URLAddress: viewModel.allCarBrands[indexPath.item].brandLogoURL ?? "") //UIImage(systemName: "car")
        
//        let url = URL(string: viewModel.brandLogoURL(of: viewModel.carBrands[indexPath.item]))
//        DispatchQueue.global().async {
//            let data = try? Data(contentsOf: url!)
//            DispatchQueue.main.async {
//                cell.squareImageView?.image = UIImage(data: data!)
//            }
//        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ChooseModelController(viewModel: viewModel)
        
        viewModel.selectedBrandName = viewModel.allCarBrands[indexPath.item].brandName ?? ""
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        .init(top: 0, left: 0, bottom: 0, right: 0) //.zero
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        0
//    }
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

