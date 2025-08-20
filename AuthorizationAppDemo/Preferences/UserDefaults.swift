//
//  UserDefaults.swift
//  AuthorizationAppDemo
//
//  Created by Kostya on 20.08.2025.
//

import Foundation

class SettingsUserDefaults {
    
    static let shared = SettingsUserDefaults()
    
    private let userDefaults = UserDefaults.standard
    private let fileDirectory = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
    private let fileExtension = "plist"
    private let keyForHavingAnAccount = "accountIsAvailable"
    private let keyForLoginReminder = "loginReminder"
    private let keyForRequestPassword = "requestPassword"
    private let keyForFaceIDSetting = "faceIDEnable"
    private let archiveHavingAnAccountURL: URL!
    private let archiveLoginReminderURL: URL!
    private let archiveRequestPasswordURL: URL!
    private let archiveFaceIDSettingURL: URL!
    
    private init() { if #available(iOS 16.0, *) {
        archiveHavingAnAccountURL = fileDirectory.appending(component: keyForHavingAnAccount).appendingPathExtension(fileExtension)
        archiveLoginReminderURL = fileDirectory.appending(component: keyForLoginReminder).appendingPathExtension(fileExtension)
        archiveRequestPasswordURL = fileDirectory.appending(component: keyForRequestPassword).appendingPathExtension(fileExtension)
        archiveFaceIDSettingURL = fileDirectory.appending(component: keyForFaceIDSetting).appendingPathExtension(fileExtension)
    } else {
        archiveHavingAnAccountURL = fileDirectory.appendingPathComponent(keyForHavingAnAccount).appendingPathExtension(fileExtension)
        archiveLoginReminderURL = fileDirectory.appendingPathComponent(keyForLoginReminder).appendingPathExtension(fileExtension)
        archiveRequestPasswordURL = fileDirectory.appendingPathComponent(keyForRequestPassword).appendingPathExtension(fileExtension)
        archiveFaceIDSettingURL = fileDirectory.appendingPathComponent(keyForFaceIDSetting).appendingPathExtension(fileExtension)
    }
    }
    
    // MARK: - Методы сохранения и получения статуса наличия аккаунта
    func saveAccountStatus(with status: UserRegistrationStatus) {
        var settings = fetchAccountStatus()
        settings = status
        
        guard let data = try? JSONEncoder().encode(settings) else { return }
        userDefaults.set(data, forKey: keyForHavingAnAccount)
    }
    
    func fetchAccountStatus() -> UserRegistrationStatus {
        guard let data = userDefaults.object(forKey: keyForHavingAnAccount) as? Data else {
            return UserRegistrationStatus(accountIsAvailable: false)
        }
        guard let status = try? JSONDecoder().decode(UserRegistrationStatus.self, from: data) else {
            return UserRegistrationStatus(accountIsAvailable: false)
        }
        return status
    }
    
    // MARK: - Методы записи, получения и удаления логина для напоминания пользователю.
    func saveLoginForReminder(with account: LoginForRemainder) {
        var login = fetchLogin()
        login = account
        
        guard let data = try? JSONEncoder().encode(login) else { return }
        userDefaults.set(data, forKey: keyForLoginReminder)
    }
    
    func fetchLogin() -> LoginForRemainder {
        guard let data = userDefaults.object(forKey: keyForLoginReminder) as? Data else {
            return LoginForRemainder(userAccountName: "")
        }
        guard let login = try? JSONDecoder().decode(LoginForRemainder.self, from: data) else {
            return LoginForRemainder(userAccountName: "")
        }
        return login
    }
    
    func deleteLogin() {
        userDefaults.removeObject(forKey: keyForLoginReminder)
    }
    
    // MARK: - Методы сохранения настройки запроса пароля при входе
    func savePasswordRequestStatus(with status: SettingsRequestPassword) {
        var settings = fetchPasswordRequestStatus()
        settings = status
        
        guard let data = try? JSONEncoder().encode(settings) else { return }
        userDefaults.set(data, forKey: keyForRequestPassword)
    }
    
    func fetchPasswordRequestStatus() -> SettingsRequestPassword {
        guard let data = userDefaults.object(forKey: keyForRequestPassword) as? Data else {
            return SettingsRequestPassword(requestPassword: false)
        }
        guard let status = try? JSONDecoder().decode(SettingsRequestPassword.self, from: data) else {
            return SettingsRequestPassword(requestPassword: false)
        }
        return status
    }
    
    // MARK: - Методы сохранения и получения настройки входа с FaceID
    func saveFaceIDSetting(with value: SettingFaceID) {
        var setting = fetchFaceIDSetting()
        setting = value
        
        guard let data = try? JSONEncoder().encode(setting) else { return }
        userDefaults.set(data, forKey: keyForFaceIDSetting)
    }
    
    func fetchFaceIDSetting() -> SettingFaceID {
        guard let data = userDefaults.object(forKey: keyForFaceIDSetting) as? Data else {
            return SettingFaceID(faceIDEnable: false)
        }
        guard let value = try? JSONDecoder().decode(SettingFaceID.self, from: data) else {
            return SettingFaceID(faceIDEnable: false)
        }
        return value
    }
}
