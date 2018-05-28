//
//  PushNotifications.swift
//  WellbefySjukskrivning
//
//  Created by Dennis Galvén on 2018-01-16.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation
import UserNotifications

class PushNotifications {
    let center = UNUserNotificationCenter.current()
    
    var hour = 7
    var minute = 0
    
    static var sharedInstance = PushNotifications()
    
    init() {
        if let hr = UserDefaults.standard.object(forKey: "hr") as? Int {
            self.hour = hr
        }
        
        if let min = UserDefaults.standard.object(forKey: "min") as? Int {
            self.minute = min
        }
    }
    
    func displayTime() -> String {
        var hourString = "\(self.hour)"
        var minuteString = "\(self.minute)"
        
        if self.hour < 10 {
            hourString = "0\(self.hour)"
        }
        
        if self.minute < 10 {
            minuteString = "0\(self.minute)"
        }
        
        return "\(hourString):\(minuteString)"
    }
    
    func changePushTime(to date: Date) {
        self.hour = Calendar.current.component(.hour, from: date)
        self.minute = Calendar.current.component(.minute, from: date)
        
        UserDefaults.standard.set(self.hour, forKey: "hr")
        UserDefaults.standard.set(self.minute, forKey: "min")
        UserDefaults.standard.synchronize()
    }
    
    private func checkSettings(completion: @escaping (Bool) -> ()) {
        center.getNotificationSettings(completionHandler: { granted in
            completion(granted.authorizationStatus == .authorized)
        })
    }
    
    func createPush() {
        checkSettings(completion: { granted in
            if granted {
                let content = UNMutableNotificationContent()
                content.sound = .default()
                content.badge = 1
                content.title = "Är du fortfarande sjuk?"
                content.body = "Glöm inte att sjukanmäla dig igen."
                
                let date = Date()
                
                let pushDate = Calendar.current.date(byAdding: .day, value: 1, to: date)
                let day = Calendar.current.component(.day, from: pushDate!)
                let month = Calendar.current.component(.month, from: pushDate!)
                let year = Calendar.current.component(.year, from: pushDate!)
                var dateComponents = DateComponents()
                dateComponents.year = year
                dateComponents.month = month
                dateComponents.day = day
                dateComponents.hour = self.hour
                dateComponents.minute = self.minute
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
//                let testTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
                let request = UNNotificationRequest(identifier: "sjuk", content: content, trigger: trigger)
                
                self.center.add(request, withCompletionHandler: {error in
                    if let aError = error {
                        debugPrint(aError.localizedDescription)
                    }
                })
            } else {
                return
            }
        })
    }
}
