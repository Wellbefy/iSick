//
//  Kid.swift
//  WellbefySjukskrivning
//
//  Created by Dennis Galvén on 2018-01-11.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation

class Kid {
    var name: String?
    var personNummer: String?
    var email: String?
    var isSick = false
    
    func setSick() {
        if isSick {
            isSick = false
        } else {
            isSick = true
        }
    }
}
