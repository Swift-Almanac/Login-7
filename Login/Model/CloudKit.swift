//
//  CloudKit.swift
//  Login
//
//  Created by Mark Hoath on 18/9/17.
//  Copyright © 2017 Mark Hoath. All rights reserved.
//

import Foundation
import CloudKit


class CKUserData {

    static let  shared = CKUserData()
    
    var users: [MyUser] = []
    var privateDB : CKDatabase = CKContainer.default().privateCloudDatabase
    
    private init() {
    }
    
    func loadUsers() {
        
        users = []
        
        print ("Load Cloudkit Users")
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "User", predicate: predicate)
        privateDB.perform(query, inZoneWith: nil) {(records: [CKRecord]?, error: Error?) in
            if error == nil {
                guard let records = records else
                {
                    print ("No Records")
                    return
                }
                for record in records {
                    let username = record.object(forKey: "username") as! String
                    let password = record.object(forKey: "password") as! String
                    print ("\(String(describing: username)), \(String(describing: password))")
                    self.addUser(username: username, password: password)
                }
            } else {
                print ("There Was an Error with CloudKit")
                print (error?.localizedDescription ?? "Error")
            }
        }
    }

    func saveUsers() {
        
        let record = CKRecord(recordType: "User")

        for user in users {
        
            record.setObject(user.username as CKRecordValue? , forKey: "username")
            record.setObject(user.password as CKRecordValue? , forKey: "password")
            privateDB.save(record) { (savedRecord: CKRecord?, error: Error?) -> Void in
                if error == nil {
                    print ("saved")
                }
            }
        }
    }
    
    func addUser(username: String, password: String) {
        let tempUser = MyUser(username: username.lowercased(), password: password)
        users.append(tempUser)
    }

    func testCloudKit() -> Bool {
        if let _ = FileManager.default.ubiquityIdentityToken {
          return true
        } else {
          return false
        }
    }
    
    func checkUser(username: String) -> LoginResults {
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

