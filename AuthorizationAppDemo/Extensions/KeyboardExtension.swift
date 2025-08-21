//
//  KeyboardExtension.swift
//  AuthorizationAppDemo
//
//  Created by Kostya on 21.08.2025.
//

import UIKit

// Cокрытие клавиатуры тапом по экрану
extension UIView {
    func makeDissmissKeyboardTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.endEditing))
        self.addGestureRecognizer(tap)
    }
}
