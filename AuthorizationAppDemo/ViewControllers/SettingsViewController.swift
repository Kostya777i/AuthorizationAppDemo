//
//  SettingsViewController.swift
//  AuthorizationAppDemo
//
//  Created by Kostya on 18.08.2025.
//

import UIKit

class SettingsViewController: UIViewController, SecuritySettingsDelegate {

    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var passwordRequestSwitchLabel: UILabel!
    @IBOutlet var faceIDSwitchLabel: UILabel!
    
    @IBOutlet var editPasswordButton: UIButton!
    @IBOutlet var deleteAccountButton: UIButton!
    @IBOutlet var logOutButton: UIButton!
    
    @IBOutlet var passwordRequestSwitch: UISwitch!
    @IBOutlet var faceIDSwitch: UISwitch!

    private let buttonCornerRadius: CGFloat = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userNameLabelSetup()
        changePasswordButtonSetup()
        deleteAccountButtonSetup()
        passwordRequestSwitchLabelSetup()
        faceIDSwitchLabelSetup()
        setPasswordRequestSwitch()
        setFaceIDSwitch()
        logOutButtonSetup()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let passwordVC = segue.destination as? PasswordViewController {
            passwordVC.transitionIdentifier = segue.identifier
            passwordVC.delegate = self
        }
    }
    
    // MARK: - IBActions
    // Кнопка выхода с анимацией
    @IBAction func logOutButtonPressed() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = scene.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "loginViewController")
            window.rootViewController = loginVC
            UIView.transition(with: window,
                              duration: 0.5,
                              options: .transitionFlipFromLeft,
                              animations: nil,
                              completion: nil)
        }
            SettingsUserDefaults.shared.savePasswordRequestStatus(with: SettingsRequestPassword(requestPassword: false))
    }
    
    @IBAction func closeButtonPressed() {
        dismiss(animated: true)
    }
    
    // Установка значения password switch из делегата
    func setCurrentValue(passwordRequest: Bool) {
        passwordRequestSwitch.isOn = passwordRequest
        setEnableSwitch(with: passwordRequest)
    }
    
    // Установка значения faceID switch из делегата
    func setCurrentValue(faceIDEnable: Bool) {
        faceIDSwitch.isOn = faceIDEnable
    }
    
    // MARK: - UISetup
    
    private func setEnableSwitch(with value: Bool) {
        faceIDSwitch.isEnabled = value
    }
    
    // Настройки переключателя запроса пароля
    private func setPasswordRequestSwitch() {
        passwordRequestSwitch.isOn = !SettingsUserDefaults.shared.fetchPasswordRequestStatus().requestPassword
    }
    
    // Настройки переключателя FaceID
    private func setFaceIDSwitch() {
        faceIDSwitch.isOn = SettingsUserDefaults.shared.fetchFaceIDSetting().faceIDEnable
        setEnableSwitch(with: passwordRequestSwitch.isOn)
    }
    
    // Настройки лейбла отображения имени пользователя
    private func userNameLabelSetup() {
        userNameLabel.text = SettingsUserDefaults.shared.fetchLogin().userAccountName
    }
    
    // Настройки кнопки смены пароля
    private func changePasswordButtonSetup() {
        editPasswordButton.setTitle("Изменить пароль", for: .normal)
        editPasswordButton.backgroundColor = .secondarySystemBackground
        editPasswordButton.layer.cornerRadius = buttonCornerRadius
    }
    
    // Настройки кнопки удаления аккаунта
    private func deleteAccountButtonSetup() {
        deleteAccountButton.setTitle("Удалить аккаунт", for: .normal)
        deleteAccountButton.tintColor = .red
        deleteAccountButton.backgroundColor = .secondarySystemBackground
        deleteAccountButton.layer.cornerRadius = buttonCornerRadius
    }
    
    // Настройки лейбла для переключателя запроса пароля при входе
    private func passwordRequestSwitchLabelSetup() {
        passwordRequestSwitchLabel.text = "Запрашивать пароль при входе"
    }
    
    // Настройки лейбла для переключателя FaceID
    private func faceIDSwitchLabelSetup() {
        faceIDSwitchLabel.text = "Разблокировать с FaceID"
    }
    
    // Настройки кнопки выхода
    private func logOutButtonSetup() {
        logOutButton.setTitle("Выйти", for: .normal)
        logOutButton.tintColor = .white
        logOutButton.backgroundColor = .blue
        logOutButton.layer.cornerRadius = buttonCornerRadius
    }
}
