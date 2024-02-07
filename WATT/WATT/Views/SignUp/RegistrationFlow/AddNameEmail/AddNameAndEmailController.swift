//
//  AddNameAndEmailController.swift
//  WATT
//
//  Created by Stas Boiko on 07.02.2024.
//

import UIKit

class AddNameAndEmailController: UIViewController {
    
    let contentView = AddNameAndEmailView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(contentView)
        contentView.fillSuperview()
        
        contentView.backButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
    }
    
    @objc private func handleBackTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
