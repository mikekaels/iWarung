//
//  UIViewController.swift
//  iWarung
//
//  Created by Santo Michael Sihombing on 24/07/21.
// hello

import UIKit

extension UINavigationController {

    var isHiddenHairline: Bool {
        get {
            guard let hairline = findHairlineImageViewUnder(navigationBar) else { return true }
            return hairline.isHidden
        }
        set {
            if let hairline = findHairlineImageViewUnder(navigationBar) {
                hairline.isHidden = newValue
            }
        }
    }

    private func findHairlineImageViewUnder(_ view: UIView) -> UIImageView? {
        if view is UIImageView && view.bounds.size.height <= 1.0 {
            return view as? UIImageView
        }

        for subview in view.subviews {
            if let imageView = self.findHairlineImageViewUnder(subview) {
                return imageView
            }
        }

        return nil
    }
}

//MARK: - Dissmiss keyboard
extension UIViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

