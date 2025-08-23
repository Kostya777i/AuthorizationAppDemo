//
//  SecuritySettingsDelegate.swift
//  AuthorizationAppDemo
//
//  Created by Kostya on 23.08.2025.
//

import Foundation

protocol SecuritySettingsDelegate {
    func setCurrentValue(passwordRequest: Bool)
    func setCurrentValue(faceIDEnable: Bool)
}
