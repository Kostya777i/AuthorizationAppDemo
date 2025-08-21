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

    @IBAction func loginButtonPressed() {
    }
    
    @IBAction func createAccountTapped() {
    }
    
    @IBAction func forgotPasswordButtonTapped() {
    }
    
    // Изменение тайтла кнопки напоминания логина и регистрации
    func changeTitleCreateAccButton() {
        if isAccountAvailable {
            createAccountButton.setTitle("Забыли логин?", for: .normal)
        } else {
            createAccountButton.setTitle("Создать аккаунт", for: .normal)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

