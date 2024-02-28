//
//  SideMenuViewController.swift
//  WATT
//
//  Created by Stas Boiko on 28.02.2024.
//

import UIKit

class SideMenuViewController: UIViewController {
    
    let contentView = SideMenuView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        view.addSubview(contentView)
        contentView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}
