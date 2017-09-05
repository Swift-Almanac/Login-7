//
//  LaunchingViewController.swift
//  Login
//
//  Created by Mark Hoath on 4/9/17.
//  Copyright © 2017 Mark Hoath. All rights reserved.
//

import UIKit

class LaunchingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //Lets Pause on the Launch Screen for 3 seconds)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            OurDefaults.shared.loadUserDefaults()
        })
    }
    
    func sendToFirstScreen(screen: UIViewController) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = screen
        self.present(screen, animated: true, completion: nil)
    }
}
