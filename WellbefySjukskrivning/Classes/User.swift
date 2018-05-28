//
//  User.swift
//  WellbefySjukskrivning
//
//  Created by Dennis Galvén on 2018-01-09.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation

class User {
    static var sharedInstance = User()
    
    var fbID: String?
    
    var name: String?
    var personNr: String = ""
    
    var fkNumber: String = ""
    
    var email: String?
    
    var kids = [Kid]()
    
    var events = [Event]()
    var sortedEvents = [[Event]]()
    let event = Event()
    
    init() {
        //Checks and retrives personNr from user defaults
        if let nr = UserDefaults.standard.string(forKey: "prsnr") {
            self.personNr = nr
        } else {
            self.personNr = ""
        }
    }
    
    //resets user
    func reset() {
        self.fbID = ""
        self.name = ""
        self.personNr = ""
        self.email = ""
        self.kids.removeAll()
        self.events.removeAll()
    }
    
    func setPrsNr(to nr: String) {
        self.personNr = nr
        
        //Saves personNr to user defaults
        UserDefaults.standard.set(nr, forKey: "prsnr")
        UserDefaults.standard.synchronize()
    }
    
    private func checkIfPrsNrExists() -> String {
        if let nr = UserDefaults.standard.string(forKey: "prsnr") {
            return nr
        } else {
            return ""
        }
    }
    
    func resetKids() {
        for kid in User.sharedInstance.kids {
            kid.isSick = false
        }
    }
    
    func getVabNr() -> [String] {
        var nummer = [String]()
        User.sharedInstance.kids.forEach {kid in
            if kid.isSick {
                nummer.append(kid.personNummer!)
            }
        }
        return nummer
    }
    func alreadySick(date: Date) -> Bool {
        var alreadySick = false
        
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        
        User.sharedInstance.events.forEach {event in
            if formatter.string(from: event.date!) == formatter.string(from: date) {
                alreadySick = true
            }
        }
        return alreadySick
    }
}
