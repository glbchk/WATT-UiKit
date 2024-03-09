//
//  MainScreenController.swift
//  WATT
//
//  Created by Glib Galchenko on 25/12/23.
//

import UIKit
import Combine

class MainViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()
    
    private let contentView = MainView()
    private var viewModel: MainViewModel
    
    private let width = UIScreen.main.bounds.width * 0.75
    private let height = UIScreen.main.bounds.height
    
    private lazy var sideMenuView = SideMenuView(viewWidth: width)
    private let sideMenuBackgroundView = UIView()
    
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
        setupSideMenuBackgroundView()
        setupSideMenuView()
        bindViewModel()
    }
    
    private func setupTarget() {
        contentView.filterButton.addTarget(self, action: #selector(filterButtonPressed), for: .touchUpInside)
        contentView.menuButton.addTarget(self, action: #selector(menuButtonPressed), for: .touchUpInside)
        sideMenuView.closeButton.addTarget(self, action: #selector(closeMenuButtonPressed), for: .touchUpInside)
        sideMenuView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(outsideMenuAreaPressed)))
        
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
    
    @objc private func filterButtonPressed() {
        let vc = ProfileViewController(viewModel: viewModel.settingsViewModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func menuButtonPressed() {
        animateSideMenuView()
    }
    
    @objc private func outsideMenuAreaPressed(sender: UITapGestureRecognizer) {
        let point = sender.location(in: sideMenuView)
        if point.x > width && isSideMenuShown {
            animateSideMenuView()
        }
    }
    
    @objc private func closeMenuButtonPressed() {
        if isSideMenuShown {
            animateSideMenuView()
        }
    }
    
}

//MARK: Side menu + animation
extension MainViewController {
    
    private func setupSideMenuView() {
        sideMenuView.frame = .init(x: -width, y: 0, width: UIScreen.main.bounds.width, height: height)
        view.addSubview(sideMenuView)
    }
    
    private func setupSideMenuBackgroundView() {
        sideMenuBackgroundView.backgroundColor = .black.withAlphaComponent(0.7)
        sideMenuBackgroundView.isHidden = true
        
        view.addSubview(sideMenuBackgroundView)
        sideMenuBackgroundView.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor)
    }
    
    func animateSideMenuView() {
        if isSideMenuShown {
            isSideMenuShown = false
            sideMenuView.isUserInteractionEnabled = false
            
            UIView.animate(withDuration: 0.3, delay: .zero, options: .curveEaseIn) {
                self.sideMenuView.frame.origin.x = -self.width
            } completion: { _ in
                self.sideMenuBackgroundView.isHidden = true
                self.sideMenuView.closeButton.isHidden = true
            }
        } else {
            isSideMenuShown = true
            sideMenuBackgroundView.isHidden = false
            sideMenuView.isUserInteractionEnabled = true
            sideMenuView.closeButton.isHidden = false
            
            UIView.animate(withDuration: 0.3, delay: .zero, options: .curveEaseIn) {
                self.sideMenuView.frame.origin.x = 0
            }
        }
        
    }
}

