//
//  AuthorizationViewController.swift
//  AuthorizationAppDemo
//
//  Created by Konstantin on 18.08.2025.
//

import UIKit

class AuthorizationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var createAccountButton: UIButton!
    @IBOutlet var forgotPasswordButton: UIButton!
    
    @IBOutlet var userNameTextFieldConstraint: NSLayoutConstraint!
    @IBOutlet var passwordTextFieldConstraint: NSLayoutConstraint!
    @IBOutlet var loginButtonConstraint: NSLayoutConstraint!
    @IBOutlet var stackViewButtonsConstraint: NSLayoutConstraint!
    @IBOutlet var userNameTFConstraintY: NSLayoutConstraint!
    
    @IBOutlet var imageView: UIImageView!
    
    var userAccountName: String {
        SettingsUserDefaults.shared.fetchLogin().userAccountName
    }
    
    private let accountData = SettingsUserDefaults.shared
    private var isAccountAvailable: Bool {
        SettingsUserDefaults.shared.fetchAccountStatus().accountIsAvailable
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI(blurBackgroundView: imageView)
        view.makeDissmissKeyboardTap()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - IBActions Кнопки "Войти" регестрация и напоминания пароля
    @IBAction func loginButtonPressed() {
        if !isAccountAvailable {
            showAlert(with: "Ошибка!", and: "Учетная не запись создана!", title: "OK")
        }
        guard let (username, password) = validateTextFields() else { return }

        if UserPasswordService.authenticate(username: username, enteredPassword: password) {
            userNameTextField.text = nil
            passwordTextField.text = nil
            performSegue(withIdentifier: "GoToMainView", sender: nil)
        } else {
            showAlert(with: "Неверный логин или пароль", and: "Попробуйте еще раз", title: "Повторить") {
                self.userNameTextField.becomeFirstResponder()
                self.passwordTextField.text = nil
            }
        }
    }
    
    @IBAction func createAccountTapped() {
        if isAccountAvailable {
            showAlert(with: "Ваш логин:", and: userAccountName, title: "OK")
        } else {
            guard let (username, password) = validateTextFields() else { return }
            
            if UserPasswordService.savePassword(username: username, password: password) {
                accountData.saveLoginForReminder(with: LoginForRemainder(userAccountName: username))
                accountData.saveAccountStatus(with: UserRegistrationStatus(accountIsAvailable: true))
                showAlert(with: "Учетная запись создана", and: "", title: "Войти") {
                    self.loginButtonPressed()
                }
            } else {
                showAlert(with: "Ошибка!", and: "Учетная не запись создана!", title: "Повторить")
            }
        }
    }
    
    @IBAction func forgotPasswordButtonTapped() {
        if let password = UserPasswordService.getPassword(for: userAccountName) {
            showAlert(with: "Ваш пароль:", and: password, title: "OK")
        } else {
            showAlert(with: "Учетная запись отсутствует", and: "", title: "ОК")
        }
    }
    
    // IBAction возврата при нажатии кнопки выход в SettingsViewController
    @IBAction func unwind(for segue: UIStoryboardSegue) {
        userNameTextField.text = nil
        passwordTextField.text = nil
    }
    
    // Переход с поля логина на поле пароля по нажатию "next" и дублирование кнопки "Войти" кнопкой "done" и "создание учетной записи"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            isAccountAvailable ? loginButtonPressed() : createAccountTapped()
        }
        return true
    }
    
    // Изменение тайтла кнопки напоминания логина и регистрации
    func changeTitleCreateAccButton() {
        if isAccountAvailable {
            createAccountButton.setTitle("Забыли логин?", for: .normal)
        } else {
            createAccountButton.setTitle("Создать аккаунт", for: .normal)
        }
    }
    
    // Проверка на nil для вызова showAlert если поле ввода пусто и получение логина и пароля
    private func validateTextFields() -> (String, String)? {
        guard let userName = userNameTextField.text, !userName.isEmpty else {
            showAlert(with: "Имя пользователя не заполнено", and: "Пожалуйста, введите имя пользователя", title: "ОК") {
                self.userNameTextField.becomeFirstResponder()
                self.passwordTextField.text = nil
            }
            return nil
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert(with: "Пароль не заполнен", and: "Пожалуйста, введите пароль", title: "OK")
            return nil
        }
        return (userName, password)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
