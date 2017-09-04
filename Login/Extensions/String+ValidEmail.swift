//
//  String+ValidEmail.swift
//  Login
//
//  Created by Mark Hoath on 4/9/17.
//  Copyright © 2017 Mark Hoath. All rights reserved.
//

import Foundation

extension String {
    
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }
}

