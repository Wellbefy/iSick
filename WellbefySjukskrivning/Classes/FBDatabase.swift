//
//  FBDatabase.swift
//  WellbefySjukskrivning
//
//  Created by Dennis Galvén on 2018-01-10.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FBDatabase {
    var userDatabase = Database.database().reference(withPath: "users")
    var fkReference = Database.database().reference(withPath: "fk")

    static let sharedInstance = FBDatabase()
    
    private func initialFetch(completion: @escaping () -> ()) {
        fetchUserName {
            self.fetchFKNumber()
            self.fetchKids {
                self.fetchHistory {
                    User.sharedInstance.event.sortedEvents()
                    completion()
                }
            }
        }
    }
    
    func getData() {
        initialFetch {
            self.sendNotification()
        }
    }
    
    func fetchUserName(completion: @escaping () -> ()) {
        userDatabase.child(User.sharedInstance.fbID!).observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists() {
                let data = snapshot.value as! NSDictionary
                User.sharedInstance.name = data.value(forKey: "name") as? String
                User.sharedInstance.email = data.value(forKey: "email") as? String
            }
            completion()
        })
    }
    
    func changeUserName(to name: String) {
        User.sharedInstance.name = name
        userDatabase.child(User.sharedInstance.fbID!).child("name").setValue(name)
        sendNotification()
    }
    
    func updateEmail(email: String) {
        User.sharedInstance.email = email
        userDatabase.child(User.sharedInstance.fbID!).child("email").setValue(email)
        sendNotification()
    }
    
    func addKid(kid: Kid) {
        let value: [String: Any] = ["personnummer": kid.personNummer!, "email": kid.email!]
        userDatabase.child(User.sharedInstance.fbID!).child("kids").child(kid.name!).setValue(value, withCompletionBlock: {_, _ in
        })
    }
    
    func removeKid(kid: Kid) {
        userDatabase.child(User.sharedInstance.fbID!).child("kids").child(kid.name!).removeValue(completionBlock: {_, _ in
        })
    }
    
    func fetchKids(completion: @escaping() -> ()) {
        User.sharedInstance.kids.removeAll()
        
        userDatabase.child(User.sharedInstance.fbID!).child("kids").observeSingleEvent(of: .value, with: {snapshot in
            if snapshot.exists() {
                for item in snapshot.children.allObjects as! [DataSnapshot] {
                    let data = item.value as! NSDictionary
                    let kid = Kid()
                    kid.name = item.key
                    kid.personNummer = data.value(forKey: "personnummer") as? String
                    kid.email = data.value(forKey: "email") as? String

                    User.sharedInstance.kids.append(kid)
                }
            }
            completion()
        })
    }
    
    func sendNotification() {
        NotificationCenter.default.post(name: NSNotification.Name("downloadDone"), object: nil)
    }
    
    func uploadEvent(name: String, vab: Bool, reported: Bool?) {
        let date = Date()
        let intervalDate = date.timeIntervalSince1970
        
        var item : [String: Any]
        
        let event = Event()
        
        event.name = name
        event.date = date
        event.dateString = event.stringFromDate()
        event.intervalDate = intervalDate
        event.vab = vab
        if let reported = reported {
            event.reportedToFk = reported
            item = ["name": name, "date": intervalDate, "vab": vab, "reported": reported]
        } else {
            item = ["name": name, "date": intervalDate, "vab": vab]
        }
        
        
        let upload = self.userDatabase.child(User.sharedInstance.fbID!).child("history").childByAutoId()
        upload.setValue(item)
        
        event.id = upload.key
        User.sharedInstance.events.append(event)
        User.sharedInstance.event.sortedEvents()
    }
    
    func removeEvent(id: String) {
        self.userDatabase.child(User.sharedInstance.fbID!).child("history").child(id).removeValue()
    }
    
    func fetchHistory(completion: @escaping() -> ()) {
        User.sharedInstance.events.removeAll()
        userDatabase.child(User.sharedInstance.fbID!).child("history").observeSingleEvent(of: .value, with: {snapshot in
            if snapshot.exists() {
                for item in snapshot.children.allObjects as! [DataSnapshot] {
                    let event = Event()
                    
                    let data = item.value as! NSDictionary
                    
                    event.id = item.key
                    event.intervalDate = data.value(forKey: "date") as? Double
                    event.name = data.value(forKey: "name") as? String
                    
                    if let vab = data.value(forKey: "vab") as? Bool {
                        event.vab = vab
                    }
                    
                    if let reported = data.value(forKey: "reported") as? Bool {
                        event.reportedToFk = reported
                    }
                    
                    event.dateFromInterval()
                    event.dateString = event.stringFromDate()
                    
                    User.sharedInstance.events.append(event)
                }
            }
            completion()
        })
    }
    
    func fetchFKNumber() {
        fkReference.child("nummer").observeSingleEvent(of: .value, with: { snapshot in
            if let nummer = snapshot.value as? String {
                User.sharedInstance.fkNumber = nummer
            }
        })
    }
}
