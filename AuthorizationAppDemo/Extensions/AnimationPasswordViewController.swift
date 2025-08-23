//
//  AnimationPasswordViewController.swift
//  AuthorizationAppDemo
//
//  Created by Kostya on 23.08.2025.
//

import UIKit

extension PasswordViewController {
    
    // Метод вызывается перед тем, как view появится на экране
    override func viewWillAppear(_ animated: Bool) {
        
        // Смещаем констрейнты неиспользуемых textField на ширину экрана, за пределы видимости.
        newPasswordTextFieldConstraint.constant += view.bounds.width
        repeatPasswordTextFieldConstraint.constant += view.bounds.width
    }
    
    /// Анимирует появление поля, устанавливая констрейнт в 0 и обновляя layout.
    /// - Parameters:
    ///   - consctraint: Констрейнт, который будет изменен для анимации появления.
    ///   - completion: Замыкание, вызываемое после завершения анимации.
    ///
    /// Метод плавно изменяет констрейнт до нуля для плавного "выезжания", появления.
    func fieldAppearanceAnimation(for consctraint: NSLayoutConstraint, completion: (() -> Void)? = nil) {
        consctraint.constant = 0
        animateLayout(duration: 0.3, delay: 0) {
            completion?()
        }
    }
    
    /// Анимирует исчезновение поля, сдвигая констрейнт за пределы экрана.
    /// - Parameter consctraint: Констрейнт, который будет изменен для анимации исчезновения.
    ///
    /// Метод сдвигает констрейнт на ширину экрана влево
    /// и вызывает анимацию обновления layout. Используется для плавного "скрытия" элемента.
    func fieldDisappearAnimation(for consctraint: NSLayoutConstraint) {
        consctraint.constant -= view.bounds.width
        animateLayout(duration: 0.3, delay: 0)
    }
}
