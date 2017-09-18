//
//  UserDefaults.swift
//  Login
//
//  Created by Mark Hoath on 4/9/17.
//  Copyright © 2017 Mark Hoath. All rights reserved.
//

import UIKit


class OurDefaults {

    static let shared = OurDefaults()

    var  username: String = ""
    var  password: String = ""
    var  autoLogin: Bool = false
    var  useiCloud: Bool = false

    private init() {
        
    }

    func loadUserDefaults() {
        
        //   Int the initial run UserDefaults will be empty so we need to run these tests.
        //   .string returns an optional.
        
        if let username = UserDefaults.standard.string(forKey: "username") {
            self.username = username
        }
        if let password = UserDefaults.standard.string(forKey: "password") {
            self.password = password
        }
        
        //  Bools have a default of false for UesrDefaults ( Initial Case)
        
        autoLogin = UserDefaults.standard.bool(forKey: "autologin")
        useiCloud = UserDefaults.standard.bool(forKey: "icloud")
                        
        if autoLogin {
            
            //   Show Home View Controller
            
            let mainStoryBoard: UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
            let homeViewController: UIViewController = mainStoryBoard.instantiateViewController(withIdentifier: "HomeNC")
            let lvc = LaunchingViewController()
            lvc.sendToFirstScreen(screen: homeViewController)
            
        } else {
            
            //Show Login View Controller
            
            if useiCloud {
                ckUserData.loadUsers()
            } else {
                userData.loadUsers()
            }

            let mainStoryBoard: UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
            let loginViewController: UIViewController = mainStoryBoard.instantiateViewController(withIdentifier: "LoginVC")
            let lvc = LaunchingViewController()
            lvc.sendToFirstScreen(screen: loginViewController)
        }
    }
    
    func saveUserDefaults(username: String, password: String, autoLogin: Bool, useiCloud: Bool) {
        self.username = username
        self.password = password
        self.autoLogin = autoLogin
        self.useiCloud = useiCloud
        
        UserDefaults.standard.set(username, forKey: "username")
        UserDefaults.standard.set(password, forKey: "password")
        UserDefaults.standard.set(autoLogin, forKey: "autologin")
        UserDefaults.standard.set(useiCloud, forKey: "icloud")
        UserDefaults.standard.synchronize()
    }
}

