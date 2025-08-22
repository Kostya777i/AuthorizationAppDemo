//
//  ShowAlert.swift
//  AuthorizationAppDemo
//
//  Created by Kostya on 22.08.2025.
//

import UIKit

extension UIViewController {
    
    /// Показывает алерт с заданным заголовком, сообщением и кнопкой.
    /// - Parameters:
    ///   - title: Заголовок алерта.
    ///   - message: Сообщение, отображаемое в алерте.
    ///   - okButton: Текст кнопки подтверждения.
    ///   - completion: Опциональное замыкание, которое будет выполнено после нажатия кнопки.
    ///
    /// ### Example:
    ///```
    /// if password == password {
    ///    showAlert(with: "Учетная запись создана", and: "", okButton: "Войти") {
    ///         self.loginButton()
    ///     }
    ///  }
    ///```
    func showAlert(with title: String,
                   and message: String,
                   title okButton: String,
                   completion: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okButton, style: .default) { _ in
            completion?()
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
