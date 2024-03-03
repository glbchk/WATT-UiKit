//
//  CustomTableView.swift
//  WATT
//
//  Created by Glib Galchenko on 01/03/24.
//

import UIKit

class CustomTableView: UITableView {
    
//    private var maxHeight: CGFloat
//    private var minHeight: CGFloat
    
    var height: CGFloat?
    
    init(height: CGFloat? = 0) {
        self.height = height
        super.init(frame: .zero, style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize {
            invalidateIntrinsicContentSize()
        }
    }
    
    override public var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        guard let height = height else { return CGSize() }
        if contentSize.height > height {
            return CGSize(width: contentSize.width, height: height)
        } else {
            return contentSize
        }
    }
    
//    override var intrinsicContentSize: CGSize {
//        layoutIfNeeded()
//        if contentSize.height > maxHeight {
//            return CGSize(width: contentSize.width, height: maxHeight)
//        } else if contentSize.height < minHeight {
//            return CGSize(width: contentSize.width, height: minHeight)
//        } else {
//            return contentSize
//        }
//    }
    
}
