//
//  AddDetailsController.swift
//  WATT
//
//  Created by Stas Boiko on 30.01.2024.
//

import UIKit

class AddDetailsController: UIViewController {
    
    let contentView = AddDetailsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(contentView)
        contentView.fillSuperview()
        
        contentView.nameEmailRow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleNameRowTap)))
        
        contentView.completeLaterButtont.addTarget(self, action: #selector(handleCompleteLater), for: .touchUpInside)
    }
    
    @objc private func handleCompleteLater() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func handleNameRowTap() {
        let vc = AddNameAndEmailController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
