//
//  AuthorizationViewControllerUISettings.swift
//  AuthorizationAppDemo
//
//  Created by Kostya on 19.08.2025.
//

import UIKit

extension AuthorizationViewController {
    
    private enum Constants {
        static let loginButtonFontSize: CGFloat = 25
        static let buttonCornerRadius: CGFloat = 6
        static let secondaryButtonsFontSize: CGFloat = 18
        static let blurAlpha: CGFloat = 0.9
    }
    
    // Функция для вызова настроек всех View
    func setupUI(blurBackgroundView: UIView) {
        userNameTextFieldSetup()
        passwordTextFieldSetup()
        loginButtonSetup()
        createAccountButtonSetup()
        forgotPasswordButtonSetup()
        blurEffectForSubView(blurBackgroundView, blurAlpha: Constants.blurAlpha)
    }
    
    // Настройки userNameTextField
    private func userNameTextFieldSetup() {
        userNameTextField.placeholder = "Логин"
        userNameTextField.autocorrectionType = .no
        userNameTextField.clearButtonMode = .whileEditing
        userNameTextField.returnKeyType = .next
        userNameTextField.delegate = self
    }
    
    // Настройки passwordTextField
    private func passwordTextFieldSetup() {
        passwordTextField.placeholder = "Пароль"
        passwordTextField.textContentType = .password
        passwordTextField.isSecureTextEntry = true
        passwordTextField.clearButtonMode = .whileEditing
        passwordTextField.returnKeyType = .go
        passwordTextField.delegate = self
    }
    
    // Настройки кнопки входа
    private func loginButtonSetup() {
        loginButton.setTitle("Войти", for: .normal)
        loginButton.titleLabel?.font = .systemFont(ofSize: Constants.loginButtonFontSize)
        loginButton.tintColor = #colorLiteral(red: 0.717726632, green: 0.6990528924, blue: 0.9738240979, alpha: 1)
        loginButton.backgroundColor = #colorLiteral(red: 0.2235294118, green: 0.1568627451, blue: 0.368627451, alpha: 0.5521630527)
        loginButton.layer.cornerRadius = Constants.buttonCornerRadius
    }
    
    // Настройки кнопки регистрации или напоминания логина
    private func createAccountButtonSetup() {
        setupButton(with: createAccountButton)
        // добавить вызов функции изменения тайтла кнопки в зависимотси от наличия регистрации или отсутствия
        createAccountButton.setTitle("Создать аккаунт", for: .normal) // Убрать после добавления функции
    }
    
    // Настройки кнопки напоминания пароля
    private func forgotPasswordButtonSetup() {
        setupButton(with: forgotPasswordButton)
        forgotPasswordButton.setTitle("Забыли пароль?", for: .normal)
    }
    
    private func setupButton(with button: UIButton) {
        button.configuration = nil
        button.tintColor = .black
        button.titleLabel?.font = .systemFont(ofSize: Constants.secondaryButtonsFontSize, weight: .light)
    }
    
    // Настройки размытия фона
    /// Добавляет эффект размытия к указанному view, если он еще не добавлен.
    /// - Parameters:
    ///   - view: Целевое view для добавления размытия
    ///   - blurAlpha: Прозрачность эффекта размытия (0.0 - 1.0)
    private func blurEffectForSubView(_ view: UIView, blurAlpha: CGFloat) {
        guard !view.subviews.contains(where: { $0 is UIVisualEffectView }) else { return }
        
        let blurEffect = UIBlurEffect(style: .systemChromeMaterialDark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = blurAlpha
        view.addSubview(blurEffectView)
    }
}
