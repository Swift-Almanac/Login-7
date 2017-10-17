//
//  ViewController.swift
//  1-Storyboard
//
//  Created by Mark Hoath on 31/8/17.
//  Copyright © 2017 Mark Hoath. All rights reserved.
//

import UIKit
import CloudKit
import Firebase
import GoogleSignIn
import FacebookCore
import FacebookLogin

class LoginViewController: UIViewController, GIDSignInUIDelegate {
    
    var activeTF = UITextField()
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var autoLoginSwitch: UISwitch!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var gcButton: UIButton!
    @IBOutlet weak var useiCloudSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailText.delegate = self
        emailText.addTarget(self, action: #selector(LoginViewController.textFieldDidChange(_:)),
                            for: UIControlEvents.editingChanged)

        
        passwordText.delegate = self
        passwordText.addTarget(self, action: #selector(LoginViewController.textFieldDidChange(_:)),
                            for: UIControlEvents.editingChanged)
        
        let faceLoginButton = UIButton(frame: CGRect(x: (view.frame.width/2) - 90, y: 120, width: 180, height: 40))
        let image = UIImage(named: "facebook")
        faceLoginButton.setImage(image, for: .normal)
        faceLoginButton.addTarget(self, action: #selector(self.loginButtonClicked), for: .touchUpInside)
        
        view.addSubview(faceLoginButton)
        
        GIDSignIn.sharedInstance().uiDelegate = self

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
    
    @objc func openSettings() {
        
        guard let settingsURL = URL(string: UIApplicationOpenSettingsURLString) else {
            print("failed")
            return
        }
        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL, completionHandler:{(success) in
                print ("SettingsOpened: \(success)")
            })
        }
    }
        
    @IBAction func useiCloudSwitch(_ sender: UISwitch) {
        
        if sender.isOn {
            print ("Test for iCloud")
            if CKUserData.shared.testCloudKit() {
                print ("CloudKit is Configured.")
            } else {
                print ("CloudKit Not Configured.")
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let currentViewController = appDelegate.window?.rootViewController
                let alert = UIAlertController(title: "Cloud Kit", message: "Go To Settings to Enable CloudKit", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Settings", style: .default) {(action) in self.openSettings()})
                currentViewController?.present(alert, animated: true, completion: nil)
                sender.isOn = false
            }
        }
        else {
            print ("No iCloud")
        }
        
    }
    
    @IBAction func gcAction(_ sender: UIButton) {
        
        openSettings()
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        
        let username = emailText.text!
        let password = passwordText.text!
        
        if OurDefaults.shared.useiCloud {
            print("Use Cloud")
            if CKUserData.shared.checkUser(username: username) == LoginResults.userNotExist {
                CKUserData.shared.addUser(username: username, password: password)
                CKUserData.shared.saveUsers()
                loginSucceeded(username: username, password: password)
            } else {
                if CKUserData.shared.login(username: username, password: password) == .loginSucceeds {
                    loginSucceeded(username: username, password: password)
                } else { // Login Failed
                    loginFailed()
                }
            }
        } else {
            print ("Use Core Data")
            if UserData.shared.checkUser(username: username) == LoginResults.userNotExist {
                UserData.shared.addUser(username: username, password: password)
                UserData.shared.saveUsers()
                loginSucceeded(username: username, password: password)
            } else {
                if UserData.shared.login(username: username, password: password) == .loginSucceeds {
                    loginSucceeded(username: username, password: password)
                }else { // Login Failed
                    loginFailed()
                }
            }
        }
    }
    
    @objc func loginButtonClicked() {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile], viewController: self) {loginResult in
            switch loginResult {
            case .failed(let error):
                print("error: \(error)")
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print(grantedPermissions)
                print(declinedPermissions)
                fbAccessToken = accessToken
                let credential = FacebookAuthProvider.credential(withAccessToken: (fbAccessToken?.authenticationToken)!)
                Auth.auth().signIn(with: credential) { (user, error) in
                    if let error = error {
                        print(error)
                        return
                    }
                    currentUser = Auth.auth().currentUser
                    moveToHomeScreen()
                    print("Logged in!")
                }
            }
        }
    }

    
    func loginSucceeded(username: String, password: String) {
        print ("Login Succeeded")
        OurDefaults.shared.saveUserDefaults(username: username, password: password, autoLogin: autoLoginSwitch.isOn, useiCloud: useiCloudSwitch.isOn)
        moveToHomeScreen()
    }
    
    func loginFailed() {
        print ("Login Failed")
        let alert = UIAlertController(title: "Login Failed", message: "Your Password is incorrect", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }
}

