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
    
    let rowView: UIView = {
        let view = UIView()
        view.constrainWidth(40)
        view.constrainHeight(40)
        view.layer.cornerRadius = 20
        return view
    }()
    
    let rowImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.constrainWidth(24)
        imgView.constrainHeight(24)
        return imgView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = Asset.Colors.black
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    let detailsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = Asset.Colors.grey1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
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
    
    var publisher: AnyPublisher<String, Never>? {
        didSet {
            bindPublisher()
        }
    }
    
    init(_ type: DetailsRowType, publisher: AnyPublisher<String, Never>? = nil) {
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
        
        rowImageView.image = type.icon?.withRenderingMode(.alwaysTemplate)
        
        label.text = type.title
        
        rowView.addSubview(rowImageView)
        rowImageView.centerInSuperview()
        
        let labelsStack = stack(label, detailsLabel, spacing: 3)
        
        let stack = hstack(rowView, labelsStack, rightArrow, spacing: 15)
        
        self.addSubview(stack)
        stack.anchor(top: self.topAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, bottom: self.bottomAnchor, padding: .allSides(15))
    }
    
    private func bindPublisher() {
        guard let publisher = publisher else { return }
        publisher
            .sink { [weak self] text in
                guard let self = self else { return }
                if !text.isEmpty {
                    self.rowView.backgroundColor = Asset.Colors.deepBlue
                    self.rowImageView.tintColor = .white
                    self.detailsLabel.text = text
                } else {
                    self.rowView.backgroundColor = Asset.Colors.grey4
                    self.rowImageView.tintColor = Asset.Colors.grey2
                    self.detailsLabel.text = ""
                }
            }
            .store(in: &cancellable)
    }
    
}
