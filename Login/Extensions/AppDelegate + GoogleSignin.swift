//
//  AppDelegate + GoogleSignin.swift
//  Login
//
//  Created by Mark Hoath on 20/9/17.
//  Copyright © 2017 Mark Hoath. All rights reserved.
//

import Foundation
import Firebase
import GoogleSignIn

var currentUser : User?

extension AppDelegate : GIDSignInDelegate {
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        
        if let error = error {
            print (error)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print (error)
                return
            }
            print ("We have Logged in")
            currentUser = Auth.auth().currentUser
            moveToHomeScreen()
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
}

func firebaseLogOut() {
    if currentUser != nil {
        OurDefaults.shared.saveUserDefaults(username: "", password: "", autoLogin: false, useiCloud: false)
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            currentUser = nil
            print("Sign Out Successful")
        } catch let signOutError {
            print ("Error signing out: \(signOutError)")
        }
    }
}
