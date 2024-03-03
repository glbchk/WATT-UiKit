//
//  ToggleView.swift
//  WATT
//
//  Created by Glib Galchenko on 01/03/24.
//

import UIKit
import Combine

class ToggleView: UISwitch {
    private var cancellables = Set<AnyCancellable>()

    var toggleStatePublisher: AnyPublisher<Bool, Never>? {
        didSet {
            switchTogglePublisher()
        }
    }
    
    let testBlueTintColor = UIColor(cgColor: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1))
    let greenTintColor = UIColor(cgColor: #colorLiteral(red: 0.2156862745, green: 0.7803921569, blue: 0.3137254902, alpha: 1))
    let greyTintColor = UIColor(cgColor: #colorLiteral(red: 0.6823529412, green: 0.7215686275, blue: 0.7843137255, alpha: 1))
    
    init() {
        super.init(frame: .zero)
        self.onTintColor = testBlueTintColor
        self.tintColor = greyTintColor
        self.toggleStatePublisher = nil
        self.constrainHeight(30)
//        self.constrainWidth(55)
//        setupTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
//    private func setupUI() {
////        guard let title = titleLabel else { return }
//
//
//        addSubview(toggle)
//
//        self.constrainHeight(30)
//        self.constrainWidth(55)
//
//        self.clipsToBounds = false
//    }
    
//    private func setupTarget() {
//        self.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
//    }
//
//    @objc private func switchValueDidChange(_ sender: Bool) {
//        if sender {
//            self.isOn = sender
//        } else {
//            self.isOn = sender
//        }
//    }
    
    private func switchTogglePublisher() {
        
        guard let togglePublisher = toggleStatePublisher else { return }
        togglePublisher
            .sink { toggle in
                if toggle {
                    self.isOn = true
                } else {
                    self.isOn = false
                }
            }
            .store(in: &cancellables)
        
    }
    
}

//extension CustomSwitch {
//
//    func offTintColor(color: UIColor) {
//        let minSide = min(bounds.size.height, bounds.size.width)
//        layer.cornerRadius = minSide / 2
//        backgroundColor = color
//        tintColor = color
//    }
//
//}
