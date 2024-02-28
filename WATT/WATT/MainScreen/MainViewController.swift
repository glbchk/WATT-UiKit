//
//  MainScreenController.swift
//  WATT
//
//  Created by Glib Galchenko on 25/12/23.
//

import UIKit
import Combine

class MainViewController: UIViewController {
    
    private lazy var contentView = MainView()
    private var viewModel: MainViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let sideMenuView = UIView()
    
    private let width = UIScreen.main.bounds.width - 100
    private let height = UIScreen.main.bounds.height
    
    private var showController = false
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(contentView)
        contentView.fillSuperview()
        
        setData()
        setupTarget()
        setupSideMenuView()
    }
    
    private func setupSideMenuView() {
        sideMenuView.frame = .init(x: -width, y: height / 2, width: width, height: height)
        sideMenuView.backgroundColor = .red
        sideMenuView.layer.cornerRadius = 30
        view.addSubview(sideMenuView)
    }
    
    private func setData() {
        viewModel.$user
            .sink { user in
                if user != nil {

                }
            }
            .store(in: &cancellables)
    }
    
    private func setupTarget() {
        contentView.signOutButton.addTarget(self, action: #selector(onPressButton), for: .touchUpInside)
        contentView.menuButton.addTarget(self, action: #selector(menuButtonPressed), for: .touchUpInside)
    }
    
    @objc private func onPressButton() {
        viewModel.signOut()
    }
    
    @objc private func menuButtonPressed() {
        showSideMenuController()
    }
    
    func showSideMenuController() {
        let sideMenuAnimation = CABasicAnimation()
        sideMenuAnimation.keyPath = "position.x"
        sideMenuAnimation.fromValue = showController ? width / 2 : -(width / 2)
        sideMenuAnimation.toValue = showController ? -(width / 2) : width / 2
        sideMenuAnimation.duration = 0.3
        
        self.sideMenuView.layer.add(sideMenuAnimation, forKey: "basic")
        self.sideMenuView.layer.position = .init(x: showController ? -(width / 2) : width / 2, y: height / 2)
        
        let menuButtonAnimation = CABasicAnimation()
        menuButtonAnimation.keyPath = "position.x"
        menuButtonAnimation.fromValue = showController ? 20 + width : 20
        menuButtonAnimation.toValue = showController ? 20 : 20 + width
        menuButtonAnimation.duration = 0.3
        
        self.contentView.menuButton.layer.add(menuButtonAnimation, forKey: "basic")
        self.contentView.menuButton.layer.position = .init(x: showController ? 20 : 20 + width, y: contentView.menuButton.frame.midY)
        
        if showController {
            showController = false
            UIView.animate(withDuration: 0.1, delay: 0.25) {
                self.contentView.searchField.alpha = 1
            }
            contentView.mapView.alpha = 1
            contentView.mapView.isUserInteractionEnabled = true
            UIView.animate(withDuration: 0.5) {
                self.contentView.locationButton.alpha = 1
            }
            UIView.animate(withDuration: 2) {
                self.contentView.menuButton.setImage(Asset.Icons.SideMenu.menu, for: .normal)
            }
            
        } else {
            showController = true
            contentView.searchField.alpha = 0
            contentView.mapView.alpha = 0.3
            contentView.mapView.isUserInteractionEnabled = false
            self.contentView.locationButton.alpha = 0
            UIView.animate(withDuration: 2) {
                self.contentView.menuButton.setImage(Asset.Icons.xmark, for: .normal)
            }
            
        }
        
    }
    
}

