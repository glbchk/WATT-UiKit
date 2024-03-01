//
//  AlertController.swift
//  WATT
//
//  Created by Stas Boiko on 18.01.2024.
//

import UIKit

class AlertController: UIViewController {
    
    let completionSubmit: (() -> Void)?
    let completionClose: (() -> Void)?
    
    let contentView: UIView
    
    let height: CGFloat
    
    let containerView = UIView()
    
    let closeButton = RoundedButton(image: Asset.Icons.xmark, size: 40, tintColor: Asset.Colors.black)
    
    let submitButtonTitle: String
    
    init(contentView: UIView, buttonTitle: String, height: CGFloat = UIScreen.main.bounds.height / 2, completionSubmit: (() -> Void)? = nil, completionClose: (() -> Void)? = nil) {
        self.contentView = contentView
        self.height = height
        self.completionSubmit = completionSubmit
        self.completionClose = completionClose
        self.submitButtonTitle = buttonTitle
        super.init(nibName: nil, bundle: nil)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func submitClicked() {
        completionSubmit?()
    }
    
    private func closeClicked() {
        completionClose?()
        dismiss(animated: true)
    }
    
    private func setupUI() {
        view.backgroundColor = .black.withAlphaComponent(0.7)
        
        containerView.backgroundColor = .white
        
        view.addSubview(containerView)
        
        containerView.layer.cornerRadius = 30
        
        containerView.centerYToSuperview()
        containerView.anchor(top: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, padding: .init(top: 0, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: height))
        
        
        setupCloseButton()
        let sbmButton = setupSubmitButton()
        
        containerView.addSubview(contentView)
        contentView.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, trailing: containerView.trailingAnchor, bottom: sbmButton.topAnchor, padding: .allSides(20))
//        contentView.centerInSuperview()
    }
    
    private func setupCloseButton() {
        containerView.addSubview(closeButton)
        
//        closeButton.backgroundColor = .white
//        closeButton.layer.cornerRadius = 20
//        closeButton.setImage(Asset.Icons.xmark, for: .normal)
//        closeButton.tintColor = Asset.Colors.black
//        
//        closeButton.setupShadow(opacity: 0.3, radius: 5, color: .black)
        
        closeButton.anchor(top: containerView.topAnchor, leading: nil, trailing: containerView.trailingAnchor, bottom: nil, padding: .init(top: -8, left: 0, bottom: 0, right: -8))
        
        closeButton.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
    }
    
    private func setupSubmitButton() -> UIButton {
        let button = MainButton(title: submitButtonTitle, shadowOpacity: 0.3, shRadius: 5, shColor: Asset.Colors.deepBlue)
        
        containerView.addSubview(button)
        
        button.anchor(top: nil, leading: containerView.leadingAnchor, trailing: containerView.trailingAnchor, bottom: containerView.bottomAnchor, padding: .allSides(20))
        
        button.addTarget(self, action: #selector(handleSubmitButton), for: .touchUpInside)
        
        return button
    }
    
    @objc private func handleClose() {
        closeClicked()
    }
    
    @objc private func handleSubmitButton() {
        submitClicked()
    }

}
