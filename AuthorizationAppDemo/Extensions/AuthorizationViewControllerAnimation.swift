//
//  AuthorizationViewControllerAnimation.swift
//  AuthorizationAppDemo
//
//  Created by Kostya on 21.08.2025.
//

import UIKit

extension AuthorizationViewController {
    
    // Метод вызывается перед тем, как view появится на экране
    override func viewWillAppear(_ animated: Bool) {
        
        // Проверка включения входа по FaceID
        if SettingsUserDefaults.shared.fetchFaceIDSetting().faceIDEnable {
            faceID() {
                self.passwordTextField.text = UserPasswordService.getPassword(for: self.userAccountName)
                self.userNameTextField.text = self.userAccountName
                self.loginButtonPressed()
            }
        }
        
        // Смещаем констрейнты на ширину экрана
        userNameTextFieldConstraint.constant += view.bounds.width
        passwordTextFieldConstraint.constant -= view.bounds.width
        loginButtonConstraint.constant += view.bounds.height
        stackViewButtonsConstraint.constant += view.bounds.height
    
        // Обновляем название кнопки создания аккаунта
        changeTitleCreateAccButton()
    }
    
    // Метод вызывается сразу после того, как view появилось на экране
    override func viewDidAppear(_ animated: Bool) {
        animateLayouts() // Запускаем анимацию изменения констрейнтов для плавного появления элементов
    }
    
    // Метод анимирует возвращение констрейнтов в исходные позиции с разными задержками и длительностью
    func animateLayouts() {
        userNameTextFieldConstraint.constant = 0
        animateLayout(duration: 0.4, delay: 0.2)
        
        passwordTextFieldConstraint.constant = 0
        animateLayout(duration: 0.4, delay: 0.4)
        
        loginButtonConstraint.constant = 45
        animateLayout(duration: 0.6, delay: 0.5)
        
        stackViewButtonsConstraint.constant = 40
        animateLayout(duration: 0.7, delay: 0.6)
    }
    
    // Метод изменяет вертикальное ограничение текстового поля, чтобы оно сдвигалось вверх и не перекрывалось клавиатурой.
    @objc func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            userNameTFConstraintY.constant = -keyboardFrame.height / 2 - 20
            UIView.animate(withDuration: 0.4) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // Метод возвращает текстовое поле в исходное положение, сбрасывая вертикальное ограничение.
    @objc func keyboardWillHide(notification: NSNotification) {
        userNameTFConstraintY.constant = -100
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
}
