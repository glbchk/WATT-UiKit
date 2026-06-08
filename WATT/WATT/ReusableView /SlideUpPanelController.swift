//
//  SlideUpPanelController.swift
//  WATT
//
//  Created by Glib Galchenko on 04/07/24.
//

import UIKit

class SlideUpPanelController: BaseViewController {
    
    let contentView: UIView
    
    let height: CGFloat
    
    let containerView = UIView()
    
    init(contentView: UIView, height: CGFloat) {
        self.contentView = contentView
        self.height = height
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        handleKeyboardAppearance()
    }
    
    private func setupUI() {
        view.backgroundColor = .black.withAlphaComponent(0.7)
        
        containerView.backgroundColor = .white
        
        view.addSubview(containerView)
        
        containerView.layer.cornerRadius = 30
        containerView.layer.maskedCorners = [ .layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        containerView.anchor(top: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: height))
        
        containerView.addSubview(contentView)
        contentView.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, trailing: containerView.trailingAnchor, bottom: containerView.bottomAnchor, padding: .init(top: 30, left: 20, bottom: 30, right: 20))
    }
    
    private func handleKeyboardAppearance() {
        handleKeyboardAppearanceAction = { [weak self] keyboardAppeared, keyboardHeight in
            guard let self = self else { return }
            if keyboardAppeared {
                view.frame.origin.y = -keyboardHeight / 2.5
            } else {
                view.frame.origin.y = 0
            }
        }
    }

}

