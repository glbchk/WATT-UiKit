//
//  SideMenuView.swift
//  WATT
//
//  Created by Stas Boiko on 28.02.2024.
//

import UIKit

class SideMenuView: UIView {
    
    private let sideMenuRows: [SideMenuRowType] = [
        .profile, .bookings, .myChargings, .myCars, .listYourCharger, .paymentMethod, .inviteFriends, .help, .feedback, .signOut
    ]
    
    let blueBackgroundView = BlueBackgroundView()
    
    private let blueBackgroundHeight = UIScreen.main.bounds.height * 0.25
    let viewWidth: CGFloat
    
    let userPhotoView = UIImageView(image: Asset.Icons.SideMenu.userPhoto?.withRenderingMode(.alwaysTemplate))
    
    let nameLabel = TextLabel(title: "Name", font: .boldSystemFont(ofSize: 18), textColor: .white)
    let emailLabel = TextLabel(title: "Email", font: .systemFont(ofSize: 13), textColor: .white)
    
    var handleSideMenuRowPressed: ((SideMenuRowType?) -> Void)?
    
    init(viewWidth: CGFloat) {
        self.viewWidth = viewWidth
        super.init(frame: .zero)
        self.backgroundColor = .white
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupBlueHeader()
        setupHeaderStack()
        setupMenuRows()
    }
    
    private func setupBlueHeader() {
        self.addSubview(blueBackgroundView)
        blueBackgroundView.anchor(top: self.topAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, bottom: nil, size: .init(width: 0, height: blueBackgroundHeight))
        blueBackgroundView.setupGradient(frame: .init(x: 0, y: 0, width: viewWidth, height: blueBackgroundHeight))
    }
    
    private func setupHeaderStack() {
        let labelStack = stack(nameLabel, emailLabel, spacing: 5)
        let stack = stack(userPhotoView, labelStack, spacing: 15)
        
        userPhotoView.constrainWidth(50)
        userPhotoView.constrainHeight(50)
        userPhotoView.tintColor = .white
        
        blueBackgroundView.addSubview(stack)
        
        stack.anchor(top: nil, leading: blueBackgroundView.leadingAnchor, trailing: blueBackgroundView.trailingAnchor, bottom: blueBackgroundView.bottomAnchor, padding: .init(top: 0, left: 35, bottom: 25, right: 35))
    }
    
    private func setupMenuRows() {
        let stack = stack()
        
        sideMenuRows.forEach {
            let view = buildMenuRow($0)
            stack.addArrangedSubview(view)
            let rowTap = SideMenuRowTap(target: self, action: #selector(sideMenuRowPressed))
            rowTap.rowType = $0
            view.addGestureRecognizer(rowTap)
        }
        
        self.addSubview(stack)
        
        stack.anchor(top: blueBackgroundView.bottomAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, bottom: nil, padding: .init(top: 15, left: 35, bottom: 0, right: 35))
    }
    
    @objc private func sideMenuRowPressed(_ sender: Any) {
        let rowType = (sender as? SideMenuRowTap)?.rowType
        handleSideMenuRowPressed?(rowType)
    }
    
    private func buildMenuRow(_ type: SideMenuRowType) -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        view.constrainHeight(50)
        let imageView = UIImageView(image: type.image?.withRenderingMode(.alwaysTemplate))
        imageView.constrainWidth(24)
        imageView.constrainHeight(24)
        imageView.tintColor = Asset.Colors.grey2
        let label = TextLabel(title: type.title, font: .systemFont(ofSize: 15), textColor: Asset.Colors.black)
        let stack = hstack(imageView, label, spacing: 20)
        view.addSubview(stack)
        stack.fillSuperview()
        return view
    }
}
