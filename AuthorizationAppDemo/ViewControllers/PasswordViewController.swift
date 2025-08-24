//
//  PasswordViewController.swift
//  AuthorizationAppDemo
//
//  Created by Kostya on 18.08.2025.
//

import UIKit

enum Identifier: String {
    case editPassword = "editPassword"
    case deleteAccount = "deleteAccount"
    case passwordRequest = "passwordRequest"
    case requestFaceID = "requestFaceID"
}

class PasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var newPasswordTextField: UITextField!
    @IBOutlet var repeatNewPasswordTextField: UITextField!
    
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    
    @IBOutlet var passwordTextFieldConstraint: NSLayoutConstraint!
    @IBOutlet var newPasswordTextFieldConstraint: NSLayoutConstraint!
    @IBOutlet var repeatPasswordTextFieldConstraint: NSLayoutConstraint!
    
    var transitionIdentifier: String?
    var delegate: SecuritySettingsDelegate?
    
    private let currentFaceIDEnable = SettingsUserDefaults.shared.fetchFaceIDSetting().faceIDEnable
    private let requestPassword = SettingsUserDefaults.shared.fetchPasswordRequestStatus().requestPassword
    private let userName = SettingsUserDefaults.shared.fetchLogin().userAccountName
    private var passwordBuffer = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.makeDissmissKeyboardTap()
        cancelButton.setTitle("Отменить", for: .normal)
        nextButtonSetup()
        setTitleLabel()
        messageLabelSetup()
        textFieldSet(for: passwordTextField, newPasswordTextField, repeatNewPasswordTextField)
    }
    
    // Изменение цвета текстовых полей для лучшей видимости при светлой теме
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if previousTraitCollection?.userInterfaceStyle == .light {
            passwordTextField.backgroundColor = .systemGray6
            newPasswordTextField.backgroundColor = .systemGray6
            repeatNewPasswordTextField.backgroundColor = .systemGray6
        }
    }
    
    // Кнопка далее
    @IBAction func nextButtonPressed() {
        if let identifier = transitionIdentifier {
            if identifier == Identifier.editPassword.rawValue {
                changePassword()
            } else if identifier == Identifier.deleteAccount.rawValue {
                deleteAccount()
            } else if identifier == Identifier.passwordRequest.rawValue {
                togglePasswordRequest()
            } else if identifier == Identifier.requestFaceID.rawValue {
                toggleRequestFaceID()
            }
        }
    }
    
    // Кнопка отмена, закрывает viewcontroller
    @IBAction func cancelButtonPressed() {
        delegate?.setCurrentValue(passwordRequest: !requestPassword)
        delegate?.setCurrentValue(faceIDEnable: currentFaceIDEnable)
        dismiss(animated: true)
    }
    
    // Дублирование на клавиатуре кнопки далее и готово
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nextButtonPressed()
        return true
    }
    
    // MARK: -  Изменение пароля
    private func changePassword() {
        if passwordTextField.isFirstResponder {
            if validateCurrentPassword(with: passwordTextField, and: UserPasswordService.self, userName: userName) {
                textFieldDidChange(self.passwordTextField)
                fieldDisappearAnimation(for: passwordTextFieldConstraint)
                fieldAppearanceAnimation(for: newPasswordTextFieldConstraint) { [weak self] in
                    self?.newPasswordTextField.becomeFirstResponder()
                }
                messageLabel.text = "Введите новый пароль"
            }
        } else if newPasswordTextField.isFirstResponder {
            guard let password = validateNewPassword(with: newPasswordTextField,
                                                     and: UserPasswordService.self, userName: userName) else { return }
            passwordBuffer = password
            newPasswordTextField.text = ""
            textFieldDidChange(self.newPasswordTextField)
            fieldDisappearAnimation(for: newPasswordTextFieldConstraint)
            fieldAppearanceAnimation(for: repeatPasswordTextFieldConstraint) { [weak self] in
                self?.repeatNewPasswordTextField.becomeFirstResponder()
            }
            messageLabel.text = "Подтвердите свой новый пароль"
            nextButton.setTitle("Готово", for: .normal)
        } else if repeatNewPasswordTextField.isFirstResponder {
            if repeatNewPasswordTextField.text == passwordBuffer {
                if UserPasswordService.savePassword(
                    username: userName,
                    password: passwordBuffer) {
                    showAlert(with: "Пароль изменен", and: "", title: "OK") {
                        self.dismiss(animated: true)
                    }
                }
            } else {
                showAlert(with: "Пароли не совпадают", and: "попробуйте еще раз", title: "OK") {
                    self.repeatNewPasswordTextField.text = nil
                    self.textFieldDidChange(self.repeatNewPasswordTextField)
                }
            }
        }
    }
    
    // MARK: - Улаление аккаунта
    private func deleteAccount() {
        if passwordTextField.text == UserPasswordService.getPassword(for: userName) {
            if UserPasswordService.deletePassword(for: userName) {
                showAlert(with: "Аккаунт был удален", and: "будет выполнен выход", title: "OK") { [weak self] in
                    SettingsUserDefaults.shared.deleteLogin()
                    SettingsUserDefaults.shared.saveAccountStatus(with: UserRegistrationStatus(accountIsAvailable: false))
                    SettingsUserDefaults.shared.savePasswordRequestStatus(with: SettingsRequestPassword(requestPassword: false))
                    SettingsUserDefaults.shared.saveFaceIDSetting(with: SettingFaceID(faceIDEnable: false))
                    
                    if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
                       let window = sceneDelegate.window {
                        UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromRight) {
                            window.rootViewController = self?.storyboard?.instantiateViewController(withIdentifier: "loginViewController")
                        }
                    }
                }
            }
        } else {
            showAlert(with: "Неверный пароль", and: "попробуйте еще раз", title: "OK") {
                self.passwordTextField.text = nil
                self.textFieldDidChange(self.passwordTextField)
            }
        }
    }
    
    // MARK: - Проверка пароля для отключения запроса при входе
    private func togglePasswordRequest() {
        if validateCurrentPassword(with: passwordTextField,
                                   and: UserPasswordService.self, userName: userName) {
            SettingsUserDefaults.shared.savePasswordRequestStatus(with: SettingsRequestPassword(requestPassword: !requestPassword))
            delegate?.setCurrentValue(passwordRequest: requestPassword)
            if !requestPassword {
                SettingsUserDefaults.shared.saveFaceIDSetting(with: SettingFaceID(faceIDEnable: false))
                delegate?.setCurrentValue(faceIDEnable: false)
            }
            dismiss(animated: true)
        }
    }
    
    // MARK: - Проверка пароля для выключения и включения FaceID
    private func toggleRequestFaceID() {
        if validateCurrentPassword(with: passwordTextField,
                                   and: UserPasswordService.self, userName: userName) {
            SettingsUserDefaults.shared.saveFaceIDSetting(with: SettingFaceID(faceIDEnable: !currentFaceIDEnable))
            delegate?.setCurrentValue(faceIDEnable: !currentFaceIDEnable)
            dismiss(animated: true)
        }
    }
    
    // MARK: -  Валидация текущего пароля
    private func validateCurrentPassword(with field: UITextField,
                                         and password: UserPasswordService.Type,
                                         userName user: String) -> Bool {
        
        if field.text == password.getPassword(for: user) {
            field.text = ""
            return true
        } else {
            showAlert(with: "Неверный пароль", and: "попробуйте еще раз", title: "OK") {
                field.text = nil
                self.textFieldDidChange(field)
            }
            return false
        }
    }
    
    // MARK: - Валидация нового пароля что бы не совподал со старым
    private func validateNewPassword(with field: UITextField,
                                     and password: UserPasswordService.Type,
                                     userName user: String) -> String? {
        
        guard let inputPassword = field.text, !inputPassword.isEmpty else {
            showAlert(
                with: "Пароль не может быть пустым",
                and: "Введите новый пароль",
                title: "OK"
            ) {
                field.text = nil
                field.sendActions(for: .editingChanged)
            }
            return nil
        }
        
        if inputPassword == password.getPassword(for: user) {
            showAlert(
                with: "Введите новый пароль",
                and: "Пароль должен отличаться от старого",
                title: "OK"
            ) {
                field.text = nil
                field.sendActions(for: .editingChanged)
            }
            return nil
        }
        
        if !checkForSpaces(with: field) {
            return nil
        }
        return inputPassword
    }
    
    // Проверка на наличее пробелов в строке
    private func checkForSpaces(with field: UITextField) -> Bool {
        guard let inputText = field.text else { return false }
        if inputText.contains(" ") {
            showAlert(with: "Введите пароль без пробелов", and: "пароль должен содержать символы", title: "OK") {
                field.text = nil
                self.textFieldDidChange(field)
            }
            return false
        } else {
            return true
        }
    }
    
    // MARK: - UISetup
    // Проверка лейблов на наличае текста и пробелов по краям текстового поля, активация кнопки далее
    @objc private func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        nextButton.isEnabled = !text.isEmpty
    }
    
    // Настройки верхнего тайтл лейбла
    private func setTitleLabel() {
        guard let identifier = transitionIdentifier else { return }
        if let identifierEnum = Identifier(rawValue: identifier) {
            switch identifierEnum {
            case .editPassword:
                titleLabel.text = "Сменить пароль"
            case .deleteAccount:
                titleLabel.text = "Удалить аккаунт"
            case .passwordRequest:
                titleLabel.text = "Запрос пароля"
            case .requestFaceID:
                titleLabel.text = "FaceID"
            }
        }
    }
    
    // Настройки кнопки далее
    private func nextButtonSetup() {
        
        if transitionIdentifier == Identifier.editPassword.rawValue {
            nextButton.setTitle("Далее", for: .normal)
        } else {
            nextButton.setTitle("Готово", for: .normal)
        }
        
        nextButton.isEnabled = false
        
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        newPasswordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        repeatNewPasswordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    // Настройки лейбла подсказок
    private func messageLabelSetup() {
        messageLabel.text = "Введите свой текущий пароль"
        messageLabel.font = .systemFont(ofSize: 14, weight: .light)
        messageLabel.textAlignment = .center
    }
    
    // Настройки passwordTextFields
    private func textFieldSet(for textFields: UITextField...) {
        textFields.enumerated().forEach { index, field in
            field.textAlignment = .center
            field.textContentType = .password
            field.isSecureTextEntry = true
            field.clearButtonMode = .whileEditing
            field.delegate = self
            if transitionIdentifier == Identifier.editPassword.rawValue {
                field.returnKeyType = index == textFields.count - 1 ? .done : .next
            } else {
                field.returnKeyType = .done
            }
        }
    }
    
    deinit {
        passwordTextField.delegate = nil
        newPasswordTextField.delegate = nil
        repeatNewPasswordTextField.delegate = nil
        passwordTextField.removeTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        newPasswordTextField.removeTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        repeatNewPasswordTextField.removeTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
}
