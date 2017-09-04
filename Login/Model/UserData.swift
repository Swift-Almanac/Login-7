//
//  UserData.swift
//  Login
//
//  Created by Mark Hoath on 4/9/17.
//  Copyright © 2017 Mark Hoath. All rights reserved.
//

import UIKit
import CoreData

enum LoginResults {
    case userNotExist
    case userExists
    case passwordFails
    case loginSucceeds
}

struct User {
    var username: String = ""
    var password: String = ""
}

class UserData {
    
    var users: [User] = []
    
    init() {
        loadUsers()
    }
    
    func loadUsers() {
        print("Loading Users")
        
        // Set users array to empty just in case
        
        users = []
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let username = result.value(forKey: "username") as? String, let password = result.value(forKey: "password") as? String {
                        
                        self.addUser(username: username, password: password)
                        
                    } else {
                        print ("Error")
                    }
                }
            }
            
        } catch {
            print ("Error")
        }
        
        for user in users {
            print("User: \(user.username), Pass: \(user.password)")
        }
        print ("Loading Complete")
    }
    
    func saveUsers() {
        print ("Saving Users")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context)
        
        for user in users {
            newUser.setValue(user.username, forKey: "username")
            newUser.setValue(user.password, forKey: "password")
            do {
                try context.save()
                print ("User Saved")
            } catch {
                print ("Error")
            }
        }
        print ("Users Saved")
    }
    
    func addUser(username: String, password: String) {
        let tempUser = User(username: username.lowercased(), password: password)
        users.append(tempUser)
    }
    
    func checkUser(username: String) -> LoginResults{
        if users.contains(where: {$0.username == username.lowercased()}) {
            return .userExists
        } else {
            return .userNotExist
        }
    }
    
    func login(username: String, password: String)->LoginResults {
        if let user = users.first(where: {$0.username == username.lowercased()}) {
            if user.password == password {
                return .loginSucceeds
            }
        }
        return .passwordFails
    }
}
