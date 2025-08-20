//
//  UserSecuritySettings.swift
//  AuthorizationAppDemo
//
//  Created by Kostya on 20.08.2025.
//

// Хранит информацию о доступности аккаунта пользователя
struct UserRegistrationStatus: Codable {
    let accountIsAvailable: Bool
}

// Хранит настройку необходимости запроса пароля при входе
struct SettingsRequestPassword: Codable {
    let requestPassword: Bool
}

// Хранит настройки включения FaceID
struct SettingFaceID: Codable {
    let faceIDEnable: Bool
}

// Хранит логин пользователя для функции напоминания
struct LoginForRemainder: Codable {
    let userAccountName: String
}
