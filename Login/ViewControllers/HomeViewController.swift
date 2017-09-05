//
//  HomeViewController.swift
//  Login
//
//  Created by Mark Hoath on 4/9/17.
//  Copyright © 2017 Mark Hoath. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LogOutAction(_ sender: UIBarButtonItem) {
        
        let mainStoryBoard: UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
        let loginViewController: UIViewController = mainStoryBoard.instantiateViewController(withIdentifier: "LoginVC")
        self.present(loginViewController, animated: true, completion: nil)
    }
}


