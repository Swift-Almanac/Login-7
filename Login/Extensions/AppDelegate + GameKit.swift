//
//  AppDelegate + GameKit.swift
//  Login
//
//  Created by Mark Hoath on 19/9/17.
//  Copyright © 2017 Mark Hoath. All rights reserved.
//

import UIKit
import GameKit

extension AppDelegate : GKGameCenterControllerDelegate {
    
    func checkGameCentre() {
        
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = { (viewController : UIViewController?, error : Error!) -> Void in
            
            if viewController != nil {
                if localPlayer.isAuthenticated {
                    OurDefaults.shared.gkPlayerID = localPlayer.playerID!
                    OurDefaults.shared.isInBackground = false
                    OurDefaults.shared.usingGameKit = true
                    OurDefaults.shared.saveUserDefaults(username: "", password: "", autoLogin: false, useiCloud: false)
                    moveToHomeScreen()
                } else {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let currentViewController = appDelegate.window?.rootViewController
                    currentViewController?.present(viewController!, animated: true, completion: nil)
                }
            } else {
                if localPlayer.isAuthenticated {
                    if OurDefaults.shared.gkPlayerID.isEmpty || OurDefaults.shared.gkPlayerID == localPlayer.playerID {
                    OurDefaults.shared.gkPlayerID = localPlayer.playerID!
                    OurDefaults.shared.isInBackground = false
                    OurDefaults.shared.usingGameKit = true
                    }
                    else {
                        gameCentreAlert(message: "A New User Has Logged In")
                        moveToHomeScreen()
                    }
                }
                else if OurDefaults.shared.autoLogin {
                    moveToHomeScreen()
                }
                else if OurDefaults.shared.isInBackground {
                    gameCentreAlert(message: "User Has Logged Out")
                    OurDefaults.shared.isInBackground = false
                    moveToLoginScreen()
                } else  {
                    moveToLoginScreen()
                }
            }
        }
    }
    
    public func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController){
        
    }

}

func gameCentreAlert(message: String) {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let currentViewController = appDelegate.window?.rootViewController
    let alert = UIAlertController(title: "Game Centre", message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    currentViewController?.present(alert, animated: true, completion: nil)
}

func moveToHomeScreen() {
    let mainStoryBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let homeViewController: UIViewController = mainStoryBoard.instantiateViewController(withIdentifier: "HomeNC")
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let currentViewController = appDelegate.window?.rootViewController
    appDelegate.window?.rootViewController = homeViewController
    currentViewController?.present(homeViewController, animated: true, completion: nil)
}

func moveToLoginScreen() {
    let mainStoryBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let loginViewController: UIViewController = mainStoryBoard.instantiateViewController(withIdentifier: "LoginVC")
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let currentViewController = appDelegate.window?.rootViewController
    appDelegate.window?.rootViewController = loginViewController
    currentViewController?.present(loginViewController, animated: true, completion: nil)
}

