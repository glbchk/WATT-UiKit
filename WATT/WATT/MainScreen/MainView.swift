//
//  MainView.swift
//  WATT
//
//  Created by Glib Galchenko on 29/01/24.
//

import UIKit
import MapKit

final class MainView: UIView {
    
    let mapView = MKMapView()
    let signOutButton = UIButton(type: .system)
    
    let searchField = SearchFieldView(height: 50)
    
    let menuButton = RoundedButton(image: Asset.Icons.SideMenu.menu, size: 50)
    
    let filterButton = RoundedButton(image: Asset.Icons.filters, size: 60)
    
    let locationButton = RoundedButton(image: Asset.Icons.location, size: 60)
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
        
        self.addSubview(signOutButton)
        signOutButton.anchor(top: nil, leading: nil, trailing: self.trailingAnchor, bottom: self.bottomAnchor, padding: .allSides(60), size: .init(width: 100, height: 20))
        
        signOutButton.setTitle("Sign out", for: .normal)
        signOutButton.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupMapView()
        setupHeaderView()
        setupFilterButton()
        setupLocationButton()
    }
    
    private func setupMapView() {
        self.addSubview(mapView)
        mapView.fillSuperview()
    }
    
    private func setupHeaderView() {
        let stack = hstack(menuButton, searchField, spacing: 15)
        self.addSubview(stack)
        stack.anchor(top: self.safeAreaLayoutGuide.topAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, bottom: nil, padding: .init(top: 0, left: 20, bottom: 0, right: 20))
        
        searchField.isActiveSearch = { [weak self] isActive in
            guard let self = self else { return }
            if isActive {
                
                animate {
                    self.menuButton.isHidden = true
                    self.menuButton.alpha = 0
                }
                
            } else {
                animate {
                    self.menuButton.isHidden = false
                    self.menuButton.alpha = 1
                }
            }
        }
    }
    
    private func setupFilterButton() {
        self.addSubview(filterButton)
        filterButton.anchor(top: nil, leading: self.leadingAnchor, trailing: nil, bottom: self.bottomAnchor, padding: .init(top: 0, left: 20, bottom: 60, right: 0))
    }
    
    private func setupLocationButton() {
        self.addSubview(locationButton)
        locationButton.anchor(top: nil, leading: nil, trailing: self.trailingAnchor, bottom: self.bottomAnchor, padding: .init(top: 0, left: 0, bottom: 60, right: 20))
    }
    
    private func animate(_ completion: @escaping () -> ()) {
        UIView.animate(withDuration: 0.3) {
            completion()
        }
    }
    
}
