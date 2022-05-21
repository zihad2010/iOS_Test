//
//  UIViewControllerExt.swift
//  iOS_Test
//
//  Created by Md. Asraful Alam on 19/5/22.
//

import UIKit

extension UIViewController {
    static func instantiate<T>(storyBoard: String? = "Main") -> T {
        let storyboard = UIStoryboard(name: storyBoard!, bundle: .main)
        let controller = storyboard.instantiateViewController(identifier: "\(T.self)") as! T
        return controller
    }
}

extension UIViewController {
    
    func hideKeyboardWhenTappedonView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
