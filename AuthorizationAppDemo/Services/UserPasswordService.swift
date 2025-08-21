//
//  UserPasswordService.swift
//  AuthorizationAppDemo
//
//  Created by Kostya on 20.08.2025.
//

import Foundation
import Security

struct UserPasswordService {
    
    private static let serviceName = "MyAppService"
    
    // Сохранение пароля в Keychain
    static func savePassword(username: String, password: String) -> Bool {
        guard let passwordData = password.data(using: .utf8) else {
            return false
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
            kSecAttrService as String: serviceName
        ]
        
        let attributesToUpdate: [String: Any] = [
            kSecValueData as String: passwordData
        ]
        
        // Попытка добавить новую запись
        let status = SecItemAdd(query.merging(attributesToUpdate) { (_, new) in new } as CFDictionary, nil)
        
        if status == errSecSuccess {
            return true
        } else if status == errSecDuplicateItem {
            // Если уже существует — обновляем
            let updateStatus = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            if updateStatus == errSecSuccess {
                return true
            } else {
                print("Не удалось обновить пароль: \(updateStatus)")
                return false
            }
        } else {
            print("Не удалось сохранить пароль: \(status)")
            return false
        }
    }
    
    // Удаление записи о логине и пароле из Keychain
    static func deletePassword(for username: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
            kSecAttrService as String: serviceName
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        if status == errSecSuccess {
            return true
        } else if status == errSecItemNotFound {
            print("Учетная запись не найдена.")
            return false
        } else {
            print("Не удалось удалить пароль: \(status)")
            return false
        }
    }
    
    // Получение пароля из хранилища
    static func getPassword(for username: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
            kSecAttrService as String: serviceName,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == errSecSuccess,
              let passwordData = item as? Data,
              let password = String(data: passwordData, encoding: .utf8) else {
            print("Не удалось получить пароль: \(status)")
            return nil
        }
        
        return password
    }
    
    // Поиск и сверка логина и пароля
    static func authenticate(username: String, enteredPassword: String) -> Bool {
        guard let savedPassword = getPassword(for: username) else {
            return false
        }
        return savedPassword == enteredPassword
    }
}
