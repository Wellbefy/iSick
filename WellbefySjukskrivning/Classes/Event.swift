//
//  Event.swift
//  WellbefySjukskrivning
//
//  Created by Dennis Galvén on 2018-01-11.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation

class Event {
    var id: String?
    var name: String?
    var dateString: String?
    var date: Date?
    var intervalDate: Double?
    var vab: Bool?
    var reportedToFk: Bool?
    
    //converts intervalDate to date for sorting
    func dateFromInterval() {
        self.date = Date.init(timeIntervalSince1970: self.intervalDate!)
    }
    
    func stringFromDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: self.date!)
    }
    
    //sorts event by date
    func sortEvents() {
        User.sharedInstance.events = User.sharedInstance.events.sorted(by: {$0.date! >= $1.date!})
    }
    
    //Groups events by month and year
    func sortedEvents() {
        let calendar = Calendar.current
        var groupedEvents = [[Event]]()
        
        let groupedDictionary = Dictionary(grouping: User.sharedInstance.events) { (event) -> Date in
            let year = calendar.component(.year, from: event.date!)
            let month = calendar.component(.month, from: event.date!)
            var component = DateComponents()
            component.year = year
            component.month = month
            component.day = 2
            let dateToSort = calendar.date(from: component)
            return dateToSort!
        }
        
        let keys = groupedDictionary.keys.sorted()
        
        keys.forEach ({
            groupedEvents.append(groupedDictionary[$0]!.reversed())
        })
        
        User.sharedInstance.sortedEvents = groupedEvents.reversed()
    }
    
    func removeEvent(id: String) {
        var counter = 0
        for event in User.sharedInstance.events {
            if event.id == id {
                User.sharedInstance.events.remove(at: counter)
            }
            counter += 1
        }
//        User.sharedInstance.sortedEvents[section].remove(at: index)
//        sortedEvents()
        FBDatabase.sharedInstance.removeEvent(id: id)
    }
    
    //checks if event is vab or not
    func isVab() -> Bool {
        if let vab = self.vab {
            return vab
        }
        return false
    }
    
    func isCurrentMonth(dateToCompare: Date) -> Bool {
        let date = Date()
        let thisMonth = Calendar.current.component(.month, from: date)
        let thisYear = Calendar.current.component(.year, from: date)
        let compareMonth = Calendar.current.component(.month, from: dateToCompare)
        let compareYear = Calendar.current.component(.year, from: dateToCompare)
        
        return thisMonth == compareMonth && thisYear == compareYear
    }
    
    //returns number of vab days
    func vabCount(section: Int = 0, force: Bool = false) -> Int {
        if User.sharedInstance.sortedEvents.isEmpty {
            return 0
        }
        
        if User.sharedInstance.sortedEvents[section].isEmpty {
            return 0
        }
        
        if !isCurrentMonth(dateToCompare: User.sharedInstance.sortedEvents[section].first!.date!) && !force {
            return 0
        }
        
        var tempDateString = ""
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        var vab = 0
        for event in User.sharedInstance.sortedEvents[section] {
            if event.isVab() && tempDateString != formatter.string(from: event.date!) {
                vab += 1
                tempDateString = formatter.string(from: event.date!)
            }
        }
        return vab
    }
    
    //returns number of sick days
    func sickCount(section: Int = 0, force: Bool = false) -> Int {
        if User.sharedInstance.sortedEvents.isEmpty {
            return 0
        }
        
        if User.sharedInstance.sortedEvents[section].isEmpty {
            return 0
        }
        
        if !isCurrentMonth(dateToCompare: User.sharedInstance.sortedEvents[section].first!.date!) && !force {
            return 0
        }
        
        var tempDateString = ""
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        var sick = 0
        for event in User.sharedInstance.sortedEvents[section] {
            if !event.isVab() && tempDateString != formatter.string(from: event.date!) {
                sick += 1
                tempDateString = formatter.string(from: event.date!)
            }
        }
        return sick
    }
}
