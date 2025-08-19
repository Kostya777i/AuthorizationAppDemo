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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    @IBAction func loginButtonPressed() {
    }
    
    @IBAction func createAccountTapped() {
    }
    
    @IBAction func forgotPasswordButtonTapped() {
    }
    
}

