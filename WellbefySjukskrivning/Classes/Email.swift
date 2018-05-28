//
//  Email.swift
//  WellbefySjukskrivning
//
//  Created by Dennis Galvén on 2018-01-23.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation

class Email {
    let backendless = Backendless.sharedInstance()
    let mailText = MailText()
    
    func sendMailUser(body: String, vab: Bool, completion: @escaping (Fault?) -> ()) {
//        var body = ""
//        if vab {
//            body = mailText.swedishVab()
//        } else {
//            body = mailText.swedishSick()
//        }
        Types.tryblock({ self.backendless!.messaging.sendTextEmail("Frånvaro", body: body, to: [User.sharedInstance.email!])
            completion(nil)
        }, catchblock: {(exception) in
            debugPrint(exception as Any)
            completion(exception as? Fault)
        })
    }
    
    func sendEmailSchool(to mailadresses: [String], body: String, completion: @escaping (Fault?) -> ()) {
        Types.tryblock({
            self.backendless!.messaging.sendTextEmail("Sjuk", body: body, to: mailadresses)
            completion(nil)
        }, catchblock: {(exception) in
            debugPrint(exception as Any)
            completion(exception as? Fault)
        })
    }
}
