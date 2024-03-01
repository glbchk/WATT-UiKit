//
//  MainScreenController.swift
//  WATT
//
//  Created by Glib Galchenko on 25/12/23.
//

import UIKit
import Combine

class MainViewController: UIViewController {
    
    private let contentView = MainView()
    private var viewModel: MainViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let width = UIScreen.main.bounds.width - 100
    private let height = UIScreen.main.bounds.height
    
    private lazy var sideMenuView: SideMenuView = SideMenuView(viewWidth: width)
    
    private var isSideMenuShown = false
    
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
    
        setupTarget()
        setupSideMenuView()
        bindViewModel()
    }
    
    private func setupTarget() {
        contentView.menuButton.addTarget(self, action: #selector(menuButtonPressed), for: .touchUpInside)
        contentView.mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideSideMenuOnMapPressed)))
        
        sideMenuView.handleSideMenuRowPressed = { [weak self] rowType in
            guard let self = self,
                  let rowType = rowType else { return }
            switch rowType {
            case .profile:
                print(rowType.title)
            case .bookings:
                print(rowType.title)
            case .myChargings:
                print(rowType.title)
            case .myCars:
                print(rowType.title)
            case .listYourCharger:
                print(rowType.title)
            case .paymentMethod:
                print(rowType.title)
            case .inviteFriends:
                print(rowType.title)
            case .help:
                print(rowType.title)
            case .feedback:
                print(rowType.title)
            case .signOut:
                self.viewModel.signOut()
            }
        }
        
    }
    
    private func bindViewModel() {
        viewModel.$user
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                guard let self = self,
                      let user = user else { return }
                self.sideMenuView.nameLabel.text = !user.isAnonymous ? user.fullName : "Anonymous user"
                self.sideMenuView.emailLabel.text = !user.isAnonymous ? user.email : ""
            }
            .store(in: &cancellables)
    }
    
    @objc private func menuButtonPressed() {
        showSideMenuView()
    }
    
    @objc private func hideSideMenuOnMapPressed() {
        if isSideMenuShown {
            showSideMenuView()
        }
    }
    
}

//MARK: Side menu + animation
extension MainViewController {
    
    private func setupSideMenuView() {
        sideMenuView.frame = .init(x: -width, y: height / 2, width: width, height: height)
        sideMenuView.layer.cornerRadius = 30
        view.addSubview(sideMenuView)
        sideMenuView.clipsToBounds = true
    }
    
    func showSideMenuView() {
        let sideMenuAnimation = CABasicAnimation()
        sideMenuAnimation.keyPath = "position.x"
        sideMenuAnimation.fromValue = isSideMenuShown ? width / 2 : -(width / 2)
        sideMenuAnimation.toValue = isSideMenuShown ? -(width / 2) : width / 2
        sideMenuAnimation.duration = 0.3
        
        self.sideMenuView.layer.add(sideMenuAnimation, forKey: "basic")
        self.sideMenuView.layer.position = .init(x: isSideMenuShown ? -(width / 2) : width / 2, y: height / 2)
        
        let menuButtonAnimation = CABasicAnimation()
        menuButtonAnimation.keyPath = "position.x"
        menuButtonAnimation.fromValue = isSideMenuShown ? 20 + width : 20
        menuButtonAnimation.toValue = isSideMenuShown ? 20 : 20 + width
        menuButtonAnimation.duration = 0.3
        
        self.contentView.menuButton.layer.add(menuButtonAnimation, forKey: "basic")
        self.contentView.menuButton.layer.position = .init(x: isSideMenuShown ? 20 : 20 + width, y: contentView.menuButton.frame.midY)
        
        if isSideMenuShown {
            isSideMenuShown = false
            UIView.animate(withDuration: 0.1, delay: 0.25) {
                self.contentView.searchField.alpha = 1
            }
            contentView.mapView.alpha = 1
            allowMapInteraction(true)
            UIView.animate(withDuration: 0.5) {
                self.contentView.locationButton.alpha = 1
            }
            UIView.animate(withDuration: 2) {
                self.contentView.menuButton.setImage(Asset.Icons.SideMenu.menu, for: .normal)
            }
            
        } else {
            isSideMenuShown = true
            contentView.searchField.alpha = 0
            contentView.mapView.alpha = 0.3
            allowMapInteraction(false)
            self.contentView.locationButton.alpha = 0
            UIView.animate(withDuration: 2) {
                self.contentView.menuButton.setImage(Asset.Icons.xmark, for: .normal)
            }
            
        }
        
    }
    
    private func allowMapInteraction(_ interaction: Bool) {
        contentView.mapView.isZoomEnabled = interaction
        contentView.mapView.isPitchEnabled = interaction
        contentView.mapView.isRotateEnabled = interaction
        contentView.mapView.isScrollEnabled = interaction
    }
    
}

