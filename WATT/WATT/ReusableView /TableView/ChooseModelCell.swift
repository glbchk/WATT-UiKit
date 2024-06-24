//
//  ChooseModelCell.swift
//  WATT
//
//  Created by Glib Galchenko on 17/04/24.
//

import UIKit

class ChooseModelCell: UITableViewCell {

    var modelId: String = ""
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = Asset.Colors.black
        
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = Asset.Colors.grey1
        
        return label
    }()

    let radioButton = CheckmarkButton()

    override init(style: UITableViewCell.CellStyle = .default, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        self.backgroundColor = .white
        
        titleLabel.text = "Model name"
        subTitleLabel.text = "Version type"
        
        let labelStack = stack(titleLabel, subTitleLabel, spacing: 2)
        let stack = hstack(labelStack, radioButton, spacing: 15)
        
        self.addSubview(stack)
        stack.anchor(top: self.topAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, bottom: self.bottomAnchor, padding: .allSides(15))
    }
    
    func updateState(_ isSelected: Bool) {
        radioButton.isChecked = isSelected
    }

}


class CheckmarkButton: UIButton {

    var isChecked: Bool = false {
        didSet {
            if isChecked {
                self.setImage(Asset.Icons.Cells.CarModelCell.checkmarkActive, for: .normal)
                self.tintColor = Asset.Colors.deepBlue
            } else {
                self.setImage(Asset.Icons.Cells.CarModelCell.checkmarkInactive, for: .normal)
                self.tintColor = Asset.Colors.grey1
            }
        }
    }
    
    init(state: Bool = false, buttonColor: UIColor = Asset.Colors.grey1, image: UIImage = Asset.Icons.Cells.CarModelCell.checkmarkInactive ?? UIImage(), size: CGSize = CGSize(width: 24, height: 24)) {
        super.init(frame: .zero)
        self.setImage(image, for: .normal)
        self.tintColor = buttonColor
        self.constrainWidth(size.width)
        self.constrainHeight(size.height)
        self.isChecked = state
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonClicked(sender: UIButton) {
        if sender == self { isChecked = !isChecked }
    }
    
}
