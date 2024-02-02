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
    }
    
}
