//
//  AddDetailRow.swift
//  WATT
//
//  Created by Stas Boiko on 03.02.2024.
//

import UIKit
import Combine

class AddDetailRow: UIView {
    private var cancellable = Set<AnyCancellable>()
    
    let accountView: UIView = {
        let view = UIView()
        view.constrainWidth(40)
        view.constrainHeight(40)
        view.layer.cornerRadius = 20
        return view
    }()
    
    let accountImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.constrainWidth(24)
        imgView.constrainHeight(24)
        return imgView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = Asset.Colors.black
        return label
    }()
    
    let detailsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = Asset.Colors.grey1
        return label
    }()
    
    let rightArrow: UIImageView = {
        let view = UIImageView(image: Asset.Icons.Navigation.chevronRight)
        view.contentMode = .scaleAspectFit
        view.tintColor = Asset.Colors.grey1
        view.constrainWidth(24)
        return view
    }()
    
    let type: DetailsRowType
    // should be user publisher
    let publisher: AnyPublisher<Bool, Never>?
    
    init(_ type: DetailsRowType, publisher: AnyPublisher<Bool, Never>?) {
        self.type = type
        self.publisher = publisher
        super.init(frame: .zero)
        setupUI()
        bindPublisher()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 15
        self.setupShadow(opacity: 0.15, radius: 5, color: .black)
        
        self.constrainHeight(70)
        
        accountImageView.image = type.icon
        
        label.text = type.title
        
        accountView.addSubview(accountImageView)
        accountImageView.centerInSuperview()
        
        let stack = hstack(accountView, stack(label, detailsLabel), rightArrow, spacing: 15)
        
        self.addSubview(stack)
        stack.anchor(top: self.topAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, bottom: self.bottomAnchor, padding: .allSides(15))
    }
    
    // should be changed due to user publisher
    private func bindPublisher() {
        guard let publisher = publisher else { return }
        publisher
            .sink { [weak self] exist in
                guard let self = self else { return }
                if exist {
                    self.accountView.backgroundColor = Asset.Colors.deepBlue
                    self.accountImageView.tintColor = .white
                    self.detailsLabel.text = "jf@gmail.com"
                } else {
                    self.accountView.backgroundColor = Asset.Colors.grey4
                    self.accountImageView.tintColor = Asset.Colors.grey2
                    self.detailsLabel.text = ""
                }
            }
            .store(in: &cancellable)
    }
    
}
