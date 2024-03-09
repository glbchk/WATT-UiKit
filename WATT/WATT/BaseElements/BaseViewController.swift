//
//  BaseViewController.swift
//  WATT
//
//  Created by Stas Boiko on 06.03.2024.
//

import UIKit

class BaseViewController: UIViewController {
    
    var handleKeyboardAppearanceAction: ((Bool, CGFloat) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(sender: Notification) {
        guard let keyboardRect = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        handleKeyboardAppearanceAction?(true, keyboardRect.height)
    }
    
    @objc private func keyboardWillHide(sender: Notification) {
        guard let keyboardRect = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        handleKeyboardAppearanceAction?(false, keyboardRect.height)
    }

}
