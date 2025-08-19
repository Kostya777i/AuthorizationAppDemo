//
//  AuthorizationViewControllerUISettings.swift
//  AuthorizationAppDemo
//
//  Created by Kostya on 19.08.2025.
//

import UIKit

extension AuthorizationViewController {
    
    // Функция для вызова настроек всех View
    func setupUI() {
        userNameTextFieldSetup()
        passwordTextFieldSetup()
        loginButtonSetup()
        createAccountButtonSetup()
        forgotPasswordButtonSetup()
        blurEffectForSubView(imageView)
    }
    
    // Настройки userNameTextField
    func userNameTextFieldSetup() {
        userNameTextField.placeholder = "Логин"
        userNameTextField.autocorrectionType = .no
        userNameTextField.clearButtonMode = .whileEditing
        userNameTextField.returnKeyType = .next
        
        self.userNameTextField.delegate = self
    }
    
    // Настройки passwordTextField
    func passwordTextFieldSetup() {
        passwordTextField.placeholder = "Пароль"
        passwordTextField.textContentType = .password
        passwordTextField.isSecureTextEntry = true
        passwordTextField.clearButtonMode = .whileEditing
        passwordTextField.returnKeyType = .go
        
        self.passwordTextField.delegate = self
    }
    
    // Настройки кнопки входа
    func loginButtonSetup() {
        loginButton.setTitle("Войти", for: .normal)
        loginButton.titleLabel?.font = .systemFont(ofSize: 25)
        loginButton.tintColor = #colorLiteral(red: 0.717726632, green: 0.6990528924, blue: 0.9738240979, alpha: 1)
        loginButton.backgroundColor = #colorLiteral(red: 0.2235294118, green: 0.1568627451, blue: 0.368627451, alpha: 0.5521630527)
        loginButton.layer.cornerRadius = 6
    }
    
    // Настройки кнопки регистрации или напоминания логина
    func createAccountButtonSetup() {
        createAccountButton.configuration = nil
        createAccountButton.tintColor = .black
        createAccountButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .light)
        // добавить вызов функции изменения тайтла кнопки в зависимотси от наличия регистрации или отсутствия
        createAccountButton.setTitle("Создать аккаунт", for: .normal) // Убрать после добавления функции
    }
    
    // Настройки кнопки напоминания пароля
   func forgotPasswordButtonSetup() {
        forgotPasswordButton.configuration = nil
        forgotPasswordButton.setTitle("Забыли пароль?", for: .normal)
        forgotPasswordButton.tintColor = .black
        forgotPasswordButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .light)
    }
    
    // Настройки размытия фона
    /// Добавляет размытие (blur) к заданному представлению.
    /// - Parameter view: UIView, к которому будет добавлен эффект размытия.
    func blurEffectForSubView(_ view: UIView) {
        let blurEffect = UIBlurEffect(style: .systemChromeMaterialDark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.9
        view.addSubview(blurEffectView)
    }
}
