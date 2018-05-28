//
//  TimePicker.swift
//  WellbefySjukskrivning
//
//  Created by Dennis Galvén on 2018-01-23.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation
import UIKit

class TimePicker: UIDatePicker {
    let timeDisplayLabel = UILabel()
    
    func setup(view: UIView) {
        self.datePickerMode = .time
        var dateComponents = DateComponents()
        self.backgroundColor = UIColor.white
        self.setValue(Colors.sharedInstance.darkGray, forKey: "textColor")
        dateComponents.hour = PushNotifications.sharedInstance.hour
        dateComponents.minute = PushNotifications.sharedInstance.minute
        let time = Calendar.current.date(from: dateComponents)
        
        self.date = time!
        
        timeDisplayLabel.textColor = Colors.sharedInstance.green
        timeDisplayLabel.font = UIFont(name: "Raleway", size: 17)
        timeDisplayLabel.text = "Påminnelse klockan \(PushNotifications.sharedInstance.displayTime()) dagen efter"
        timeDisplayLabel.textAlignment = .center
        timeDisplayLabel.numberOfLines = 0
        self.addSubview(timeDisplayLabel)
        timeDisplayLabel.translatesAutoresizingMaskIntoConstraints = false
        [
            timeDisplayLabel.bottomAnchor.constraint(equalTo: self.topAnchor),
            timeDisplayLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            timeDisplayLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            timeDisplayLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30)
            ].forEach {$0.isActive = true}
    }
    
    func updateLabel() {
        self.timeDisplayLabel.text = "Påminnelse klockan \(PushNotifications.sharedInstance.displayTime()) dagen efter"
    }
}
