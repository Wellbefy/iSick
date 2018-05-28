//
//  FBAuth.swift
//  WellbefySjukskrivning
//
//  Created by Dennis Galvén on 2018-01-10.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class FBAuth {
    
    func checkIfLoggedIn(completion: @escaping (Bool) -> ()) {
        Auth.auth().addStateDidChangeListener({_, user in
            if user != nil {
                User.sharedInstance.fbID = user!.uid
            } else {
                User.sharedInstance.fbID = ""
            }
            completion(user == nil)
        })
    }
    
    func tryToLogin(email: String, password: String, completion: @escaping (Bool, Error?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { user, error in
            if error != nil {
                let errorcode = AuthErrorCode(rawValue: error!._code)
                completion(errorcode! == AuthErrorCode.userNotFound, error)
            } else {
                let database = FBDatabase()
                database.fetchUserName {
                    completion(false, nil)
                }
            }
        })
    }
    
    func createUser(email: String, password: String, name: String, mailToEmployeer: String, completion: @escaping (Error?) -> ()) {
        let value : [String: Any] = ["name": name, "email": mailToEmployeer]
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { user, error in
            if user != nil {
                Database.database().reference(withPath: "users").child(user!.user.uid).setValue(value)
                User.sharedInstance.name = name
                User.sharedInstance.email = mailToEmployeer
            }
            completion(error)
        })
    }
    
    func passwordReset(email: String, completion: @escaping (Error?) -> ()) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: { error in
            completion(error)
        })
    }
    
    func signOut() {
        UserDefaults.standard.removeObject(forKey: "prsnr")
        UserDefaults.standard.removeObject(forKey: "hr")
        UserDefaults.standard.removeObject(forKey: "min")
        UserDefaults.standard.synchronize()
        
        PushNotifications.sharedInstance = PushNotifications()
        
        User.sharedInstance.reset()
        do {
            try Auth.auth().signOut()
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}
