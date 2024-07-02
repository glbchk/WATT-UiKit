//
//  AlertController.swift
//  WATT
//
//  Created by Stas Boiko on 18.01.2024.
//

import UIKit

class AlertController: BaseViewController {
    
    let completionSubmit: (() -> Void)?
    let completionClose: (() -> Void)?
    
    let contentView: UIView
    
    let height: CGFloat
    
    let containerView = UIView()
    
    let closeButton = RoundedButton(image: Asset.Icons.xmark, size: 40, tintColor: Asset.Colors.black)
    
    let submitButtonTitle: String
    
    private var keyboardIsShown: Bool = false
    
    init(contentView: UIView, buttonTitle: String, height: CGFloat, completionSubmit: (() -> Void)? = nil, completionClose: (() -> Void)? = nil) {
        self.contentView = contentView
        self.height = height
        self.completionSubmit = completionSubmit
        self.completionClose = completionClose
        self.submitButtonTitle = buttonTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        handleKeyboardAppearance()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(outsideAlertAreaPressed)))
    }
    
    @objc private func outsideAlertAreaPressed(sender: UITapGestureRecognizer) {
        let tapPoint = sender.location(in: self.view)
        if tapPoint.y > (UIScreen.main.bounds.height / 2 - height / 2) && tapPoint.y < (UIScreen.main.bounds.height / 2 + height / 2) {
            view.endEditing(true)
        } else if tapPoint.y < (UIScreen.main.bounds.height / 2 - height / 2) || tapPoint.y > (UIScreen.main.bounds.height / 2 + height / 2) {
            if keyboardIsShown {
                view.endEditing(true)
            } else {
                closeClicked()
            }
        }
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
    }
    
    private func setupCloseButton() {
        containerView.addSubview(closeButton)
        
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
    
    private func handleKeyboardAppearance() {
        handleKeyboardAppearanceAction = { [weak self] keyboardAppeared, keyboardHeight in
            guard let self = self else { return }
            if keyboardAppeared {
                view.frame.origin.y = -keyboardHeight / 2.5
                self.keyboardIsShown = true
            } else {
                view.frame.origin.y = 0
                self.keyboardIsShown = false
            }
        }
    }

}
