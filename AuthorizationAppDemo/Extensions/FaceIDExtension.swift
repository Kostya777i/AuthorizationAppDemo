//
//  FaceIDExtension.swift
//  AuthorizationAppDemo
//
//  Created by Kostya on 23.08.2025.
//

import LocalAuthentication

extension AuthorizationViewController {
    
    /// Выполняет аутентификацию пользователя с помощью Face ID.
    /// При успешной аутентификации вызывает переданное замыкание `completion`.
    /// - Parameter completion: Замыкание, которое будет выполнено на главном потоке
    ///   после успешного прохождения аутентификации.
    ///
    /// - Note: Если устройство не поддерживает биометрию или проверка невозможна,
    ///   функция вызывает `showAlert(...)` для отображения сообщения о необходимости
    ///   альтернативного ввода логина и пароля.
    ///
    /// - Important: Замыкание `completion` выполняется только при **успешной**
    ///   аутентификации.
    ///
    /// Example:
    /// ```swift
    /// faceID {
    ///     self.passwordTextField.text = UserPasswordService.getPassword(for: self.userAccountName)
    ///     self.userNameTextField.text = self.userAccountName
    ///     self.loginButtonPressed()
    /// }
    /// ```
    func faceID(completion: @escaping () -> Void) {
        let context = LAContext()
        var error: NSError?
        let reason = "Войдите в свою учетную запись"
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            print(error?.localizedDescription ?? "Can't evaluate policy")
            showAlert(with: "Вернуться", and: "к вводу имени пользователя и пароля", title: "OK")
    
            return
        }
        
        context.evaluatePolicy(
            .deviceOwnerAuthentication, localizedReason: reason
        ) { success, error in
            DispatchQueue.main.async {
                guard success, error == nil else { return }
                completion()
            }
        }
    }
}
