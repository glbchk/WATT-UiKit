//
//  AddCarView.swift
//  WATT
//
//  Created by Glib Galchenko on 03/03/24.
//

import UIKit

class AddCarView: UIView {
    
    let blueBackgroundView = BlueBackgroundView()
    
    let blueBackgroundHeight = UIScreen.main.bounds.height * 0.29
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(Asset.Icons.Navigation.chevronLeft, for: .normal)
        button.tintColor = .white
        button.imageView?.fillSuperview()
        button.widthAnchor.constraint(equalToConstant: 18).isActive = true
        button.heightAnchor.constraint(equalToConstant: 24).isActive = true
        return button
    }()
    
    let titleLabel = TextLabel(title: "Add your car", font: .systemFont(ofSize: 28, weight: .bold), textColor: .white, numberOfLines: 0)
    let subtitleLabel = SecondaryLabel(text: "Select your car", textColor: .white, numbersOfLines: 0, textAlignment: .natural)
    
    let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        
        return layout
    }()
    
    var carsCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        return view
    }()
    var carsCollectionBottomSize: CGFloat = 0
    
    let bgSaveCarButton = UIView()
    let saveCarsButton = MainButton(title: "Save", titleColor: .white, backgroundColor: Asset.Colors.deepBlue, shadowOpacity: 0.15, shRadius: 5, shColor: .black)
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupBlueHeader()
        setupBackButton()
        setupLabels()
        
        setupCarBrandsCollectionView()
        saveAddedCarsButton()
    }
    
    private func setupBlueHeader() {
        self.addSubview(blueBackgroundView)
        blueBackgroundView.anchor(top: self.topAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, bottom: nil, size: .init(width: 0, height: blueBackgroundHeight))
        blueBackgroundView.setupGradient(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: blueBackgroundHeight))
    }
    
    private func setupBackButton() {
        blueBackgroundView.addSubview(backButton)
        backButton.anchor(top: self.safeAreaLayoutGuide.topAnchor, leading: blueBackgroundView.leadingAnchor, trailing: nil, bottom: nil, padding: .init(top: 20, left: 26, bottom: 0, right: 0))
    }
    
    private func setupLabels() {
        let stack = stack(titleLabel, subtitleLabel, spacing: 6)
        blueBackgroundView.addSubview(stack)
        stack.anchor(top: backButton.bottomAnchor, leading: blueBackgroundView.leadingAnchor, trailing: blueBackgroundView.trailingAnchor, bottom: nil, padding: .init(top: 20, left: 20, bottom: 0, right: 20))
    }
    
    private func setupCarBrandsCollectionView() {
        carsCollectionView.collectionViewLayout = layout
        carsCollectionView.backgroundColor = .clear
        carsCollectionView.clipsToBounds = true
        carsCollectionView.contentInset.bottom = 120
        
        self.addSubview(carsCollectionView)
        
        carsCollectionView.anchor(top: subtitleLabel.bottomAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, bottom: self.bottomAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        }
    
    private func saveAddedCarsButton() {
        bgSaveCarButton.backgroundColor = .white
        bgSaveCarButton.heightAnchor.constraint(equalToConstant: 124).isActive = true
        bgSaveCarButton.setupShadow(opacity: 0.1, radius: 30, color: .black)
        bgSaveCarButton.addSubview(saveCarsButton)
        
        self.addSubview(bgSaveCarButton)
        bgSaveCarButton.anchor(top: nil, leading: self.leadingAnchor, trailing: self.trailingAnchor, bottom: self.bottomAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        saveCarsButton.anchor(top: bgSaveCarButton.topAnchor, leading: bgSaveCarButton.leadingAnchor, trailing: bgSaveCarButton.trailingAnchor, bottom: nil, padding: .init(top: 20, left: 20, bottom: 0, right: 20))
    }
    
}
