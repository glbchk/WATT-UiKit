//
//  AddCarController.swift
//  WATT
//
//  Created by Glib Galchenko on 03/03/24.
//

import UIKit
import Combine

class AddCarController: UIViewController {
    
    let contentView = AddCarView()
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

        contentView.carsView.delegate = self
        contentView.carsView.dataSource = self
        contentView.carsView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "car1")
        
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
        return 4
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: UIScreen.main.bounds.width - 40, height: 90)
//    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "car1", for: indexPath)
        cell.backgroundColor = UIColor(.black)
        
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Asset.Identifiers.CollectionCell.carCell, for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
//        cell.titleLabel.text = viewModel.fakeDataCollection[indexPath.item].title
//        cell.squareImageView?.image = viewModel.fakeDataCollection[indexPath.item].image.image
//
        return cell
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
