//
//  ViewController.swift
//  1-Storyboard
//
//  Created by Mark Hoath on 31/8/17.
//  Copyright © 2017 Mark Hoath. All rights reserved.
//

import UIKit


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
        
        setDefaultValues()
        checkLoginButtonActive()
    }
    
    func setDefaultValues() {
        emailText.text = ourDefaults.username
        passwordText.text = ourDefaults.password
        autoLoginSwitch.isOn = ourDefaults.autoLogin
    }
    
    
    func checkLoginButtonActive() {
        if (emailText.text?.isEmpty)! || (passwordText.text?.isEmpty)! || (!(emailText.text?.isValidEmail())!) {
            loginButton.isEnabled = false
        } else {
            loginButton.isEnabled = true
        }
    }
    
    func saveUserDefaults(username: String, password: String) {
        if autoLoginSwitch.isOn {
            ourDefaults.saveUserDefaults(username: username, password: password, autoLogin: autoLoginSwitch.isOn)
        }
        else {
            ourDefaults.saveUserDefaults(username: "", password: "", autoLogin: false)
        }
    }
    
    func moveToHomeController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc  = storyboard.instantiateViewController(withIdentifier: "HomeNC") as! UINavigationController
        show(vc, sender: self)
    }

    @IBAction func loginButton(_ sender: UIButton) {
        
        let username = emailText.text!
        let password = passwordText.text!
        
        if userData.checkUser(username: username) == LoginResults.userNotExist {
            userData.addUser(username: username, password: password)
            userData.saveUsers()
            saveUserDefaults(username: username, password: password)
            moveToHomeController()
        } else {
            if userData.login(username: username, password: password) == .loginSucceeds {
                print ("Login Succeeded")
                saveUserDefaults(username: username, password: password)
                moveToHomeController()
            }else { // Login Failed
                print ("Login Failed")
                let alert = UIAlertController(title: "Login Failed", message: "Your Password is incorrect", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

