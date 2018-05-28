//
//  TabBarVC.swift
//  WellbefySjukskrivning
//
//  Created by Dennis Galvén on 2018-01-10.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Removes badges
        UIApplication.shared.applicationIconBadgeNumber = 0
        checkLogin()
    }
    
    func checkLogin() {
        let auth = FBAuth()
        
        auth.checkIfLoggedIn(completion: { loggedOut in
            if loggedOut {
                self.performSegue(withIdentifier: "tologin", sender: nil)
            } else {
                let database = FBDatabase()
                database.getData()
                self.performSegue(withIdentifier: "loading", sender: nil)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
