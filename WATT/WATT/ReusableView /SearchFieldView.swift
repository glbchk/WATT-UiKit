//
//  SearchFieldView.swift
//  WATT
//
//  Created by Stas Boiko on 28.02.2024.
//

import UIKit

class SearchFieldView: UIView, UITextFieldDelegate {
    
    let textField = TextFieldWithPlaceholder("Search query")
    
    private let searchImageView = UIImageView(image: Asset.Icons.magnifyingglass)
    
    var isActiveSearch: ((Bool) -> Void)?
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(Asset.Icons.xmark, for: .normal)
        button.tintColor = Asset.Colors.black
        button.constrainWidth(24)
        button.constrainHeight(24)
        button.isHidden = true
        button.isEnabled = false
        return button
    }()
    
    init(height: CGFloat) {
        super.init(frame: .zero)
        setupUI()
        textField.delegate = self
        self.constrainHeight(height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
        self.setupShadow(opacity: 0.3, radius: 5, color: .black)
        
        searchImageView.contentMode = .center
        searchImageView.constrainWidth(24)
        searchImageView.constrainHeight(24)
        
        let stack = hstack(searchImageView, textField, closeButton, spacing: 10)
        
        self.addSubview(stack)
        stack.anchor(top: self.topAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, bottom: self.bottomAnchor, padding: .init(top: 10, left: 15, bottom: 10, right: 15))
        
        searchImageView.tintColor = Asset.Colors.grey2
        
        closeButton.addTarget(self, action: #selector(closeSearch), for: .touchUpInside)
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchImageView.tintColor = Asset.Colors.deepBlue
        closeButton.isHidden = false
        closeButton.isEnabled = true
        isActiveSearch?(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchImageView.tintColor = Asset.Colors.grey2
        closeButton.isHidden = true
        closeButton.isEnabled = false
        isActiveSearch?(false)
    }
    
    @objc private func closeSearch() {
        textField.resignFirstResponder()
    }
    
}
