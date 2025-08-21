//
//  UIViewControllerAnimate.swift
//  AuthorizationAppDemo
//
//  Created by Kostya on 21.08.2025.
//

import UIKit

extension UIViewController {
    
    /// Запускает анимацию обновления компоновки представления с заданной длительностью и задержкой.
    /// - Parameters:
    ///   - duration: Время выполнения анимации в секундах.
    ///   - delay: Задержка перед началом анимации в секундах.
    ///   - completion: Замыкание, вызываемое после завершения анимации.
    ///
    /// Анимация плавно вызывает `layoutIfNeeded()` у основного представления контроллера,
    /// что позволяет обновить расположение элементов интерфейса с анимацией.
    /// Используется слабая ссылка на `self [weak self]`  для предотвращения цикла удержания и утечек памяти,
    /// а также для безопасного выполнения, если объект уже уничтожен к моменту запуска анимации.
    func animateLayout(duration: Double, delay: Double, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, delay: delay, options: [.curveEaseInOut]) { [weak self] in
            self?.view.layoutIfNeeded()
        } completion: { _ in
            completion?()
        }
    }
}
