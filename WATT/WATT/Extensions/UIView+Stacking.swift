//
//  UIView+Stacking.swift
//  WATT
//
//  Created by Stas Boiko on 18.01.2024.
//

import UIKit

extension UIView {
    
    private func _stack(_ axis: NSLayoutConstraint.Axis = .vertical, views: [UIView], spacing: CGFloat = 0, alignment: UIStackView.Alignment = .leading, distribution: UIStackView.Distribution = .fill) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.alignment = alignment
        stackView.distribution = distribution
        addSubview(stackView)
//        stackView.fillSuperview()
        return stackView
    }
    
    @discardableResult
    public func stack(_ views: UIView..., spacing: CGFloat = 0, alignment: UIStackView.Alignment = .leading, distribution: UIStackView.Distribution = .fill) -> UIStackView {
        return _stack(.vertical, views: views, spacing: spacing, alignment: alignment, distribution: distribution)
    }
    
    @discardableResult
    public func hstack(_ views: UIView..., spacing: CGFloat = 0, alignment: UIStackView.Alignment = .center, distribution: UIStackView.Distribution = .fill) -> UIStackView {
        return _stack(.horizontal, views: views, spacing: spacing, alignment: alignment, distribution: distribution)
    }
}
