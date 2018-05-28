//
//  AlertController.swift
//  WellbefySjukskrivning
//
//  Created by Dennis Galvén on 2018-01-10.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation
import UIKit

class Alertcontroller {
    func oneAction(message: String) -> UIAlertController {
        let alert = UIAlertController()
        alert.title = "Ojdå!"
        alert.message = message
        alert.view.backgroundColor = UIColor.white
        alert.view.layer.cornerRadius = 10
        let oneAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(oneAction)
        return alert
    }
    
    func twoAction(title: String, message: String, completion: @escaping (Bool) -> ()) -> UIAlertController {
        let alert = UIAlertController()
        alert.title = title
        alert.message = message
        alert.view.backgroundColor = UIColor.white
        alert.view.layer.cornerRadius = 10
        let oneAction = UIAlertAction(title: "JA", style: .default, handler: {_ in
            completion(true)
        })
        
        let twoAction = UIAlertAction(title: "NEJ", style: .destructive, handler: {_ in
            completion(false)
        })
        
        alert.addAction(oneAction)
        alert.addAction(twoAction)
        return alert
    }
    
    func sucsessDialog(message: String, completion: @escaping () -> ()) -> UIAlertController {
        let alert = UIAlertController()
        alert.title = "Succé!"
        alert.message = message
        alert.view.backgroundColor = UIColor.white
        alert.view.layer.cornerRadius = 10
        let oneAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion()
        })
        
        alert.addAction(oneAction)
        return alert
    }
}
