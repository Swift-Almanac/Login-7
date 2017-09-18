//
//  ViewController.swift
//  1-Storyboard
//
//  Created by Mark Hoath on 31/8/17.
//  Copyright © 2017 Mark Hoath. All rights reserved.
//

import UIKit
import CloudKit


class LoginViewController: UIViewController {
    
    var activeTF = UITextField()
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var autoLoginSwitch: UISwitch!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var useiCloudSwitch: UISwitch!
    
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
        emailText.text = OurDefaults.shared.username
        passwordText.text = OurDefaults.shared.password
        autoLoginSwitch.isOn = OurDefaults.shared.autoLogin
        useiCloudSwitch.isOn = OurDefaults.shared.useiCloud
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
            OurDefaults.shared.saveUserDefaults(username: username, password: password, autoLogin: autoLoginSwitch.isOn, useiCloud: useiCloudSwitch.isOn)
        }
        else {
            OurDefaults.shared.saveUserDefaults(username: "", password: "", autoLogin: false, useiCloud: useiCloudSwitch.isOn)
        }
    }
    
    func moveToHomeController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc  = storyboard.instantiateViewController(withIdentifier: "HomeNC") as! UINavigationController
        show(vc, sender: self)
    }
    
    @IBAction func useiCloudSwitch(_ sender: UISwitch) {
        
        if sender.isOn {
            print ("Test for iCloud")
            if ckUserData.testCloudKit() {
                print ("CloudKit is Configured.")
            } else {
                print ("CloudKit Not Configured.")
                // Need an Alert set Use iCloud to Off !
                sender.isOn = false
            }
        }
        else {
            print ("No iCloud")
        }
        
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        
        let username = emailText.text!
        let password = passwordText.text!
        
        if OurDefaults.shared.useiCloud {
            print("Use Cloud")
            if ckUserData.checkUser(username: username) == LoginResults.userNotExist {
                ckUserData.addUser(username: username, password: password)
                ckUserData.saveUsers()
                loginSucceeded(username: username, password: password)
            } else {
                if ckUserData.login(username: username, password: password) == .loginSucceeds {
                    loginSucceeded(username: username, password: password)
                } else { // Login Failed
                    loginFailed()
                }
            }
        } else {
            print ("Use Core Data")
            if userData.checkUser(username: username) == LoginResults.userNotExist {
                userData.addUser(username: username, password: password)
                userData.saveUsers()
                loginSucceeded(username: username, password: password)
            } else {
                if userData.login(username: username, password: password) == .loginSucceeds {
                    loginSucceeded(username: username, password: password)
                }else { // Login Failed
                    loginFailed()
                }
            }
        }
    }
    
    func loginSucceeded(username: String, password: String) {
        print ("Login Succeeded")
        OurDefaults.shared.saveUserDefaults(username: username, password: password, autoLogin: autoLoginSwitch.isOn, useiCloud: useiCloudSwitch.isOn)
        moveToHomeController()
    }
    
    func loginFailed() {
        print ("Login Failed")
        let alert = UIAlertController(title: "Login Failed", message: "Your Password is incorrect", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }
}

