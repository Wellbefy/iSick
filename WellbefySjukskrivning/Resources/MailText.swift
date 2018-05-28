//
//  MailText.swift
//  WellbefySjukskrivning
//
//  Created by Dennis Galvén on 2018-01-15.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation
import UIKit

struct MailText {
    func swedishSickKid(named: String, personNumber: String) -> String {
        return "\(date())\n\nHej,\n\n\(named), \(personNumber), är sjuk idag.\n\nSkickat via\niSick\n'appen för snabb frånvaroanmälan'"
    }
    
    func swedishSick() -> String {
        return "\(date())\n\nHej,\n\n\(User.sharedInstance.name!), \(User.sharedInstance.personNr), är sjuk idag.\n\nSkickat via\niSick\n'appen för snabb frånvaroanmälan'"
    }
    
    func swedishVab() -> String {
        return "\(date())\n\nHej,\n\n\(User.sharedInstance.name!), \(User.sharedInstance.personNr), är hemma med sjukt barn idag.\n\nSkickat via\niSick\n'appen för snabb frånvaroanmälan'"
    }
    
    func date() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        return formatter.string(from: date)
    }
}
