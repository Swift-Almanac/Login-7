//
//  ViewController.swift
//  1-Storyboard
//
//  Created by Mark Hoath on 31/8/17.
//  Copyright © 2017 Mark Hoath. All rights reserved.
//

import UIKit

var userData = UserData()

class LoginViewController: UIViewController {
    
    var activeTF = UITextField()
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var autoLoginSwitch: UISwitch!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailText.delegate = self
        emailText.addTarget(self, action: #selector(LoginViewController.textFieldDidChange(_:)),
                            for: UIControlEvents.editingChanged)

        
        passwordText.delegate = self
        passwordText.addTarget(self, action: #selector(LoginViewController.textFieldDidChange(_:)),
                            for: UIControlEvents.editingChanged)
        
        checkLoginButtonActive()

    }
    
    
    func checkLoginButtonActive() {
        if (emailText.text?.isEmpty)! || (passwordText.text?.isEmpty)! || (!(emailText.text?.isValidEmail())!) {
            loginButton.isEnabled = false
        } else {
            loginButton.isEnabled = true
        }
    }
    
    
    @IBAction func loginButton(_ sender: UIButton) {
        
        let username = emailText.text!
        let password = passwordText.text!
        
        if userData.checkUser(username: username) == LoginResults.userNotExist {
            userData.addUser(username: username, password: password)
            userData.saveUsers()
            //  Write to User Defaults
            //  Move to Main View
            
        } else {
            if userData.login(username: username, password: password) == .loginSucceeds {
                print ("Login Succeeded")
                
                // Write to UserDeafults
                // Move to Main View
                
            }else { // Login Failed
                print ("Login Failed")
                
                //   Show an Alert
            }
            
        }
    }
    
}

