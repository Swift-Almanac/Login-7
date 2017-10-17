//
//  LoginViewController+TextField.swift
//  Login
//
//  Created by Mark Hoath on 4/9/17.
//  Copyright © 2017 Mark Hoath. All rights reserved.
//

import UIKit

extension LoginViewController: UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        checkLoginButtonActive()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTF = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {

    }
}
