//
//  CircleAnimations.swift
//  WellbefySjukskrivning
//
//  Created by Dennis Galvén on 2018-02-06.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation
import UIKit

extension HistoryVC {
    func addCircles() {
        leftView.backgroundColor = UIColor.clear
        middleView.backgroundColor = UIColor.clear
        rightView.backgroundColor = UIColor.clear
        
        let circleLeft = ShapeLayers()
        circleLeft.circle(at: leftView.center, size: (leftView.frame.height / 2) - 10, animation: false)
        circleLeft.strokeColor = Colors.sharedInstance.darkGray.cgColor
        let circleMiddle = ShapeLayers()
        circleMiddle.circle(at: middleView.center, size: (middleView.frame.height / 2) - 10, animation: false)
        circleMiddle.strokeColor = Colors.sharedInstance.darkGrayAlpha.cgColor
        let circleRight = ShapeLayers()
        circleRight.circle(at: rightView.center, size: (rightView.frame.height / 2) - 10, animation: false)
        circleRight.strokeColor = Colors.sharedInstance.darkGrayAlpha.cgColor
        
        view.layer.addSublayer(circleLeft)
        view.layer.addSublayer(circleMiddle)
        view.layer.addSublayer(circleRight)
    }
    
    func addAnimationCircles() {
        sickPercentCircle = ShapeLayers()
        sickPercentCircle.strokeColor = Colors.sharedInstance.green.cgColor
        sickPercentCircle.circle(at: leftView.center, size: (leftView.frame.height / 2) - 10, animation: true)
        
        vabPercentCircle = ShapeLayers()
        vabPercentCircle.strokeColor = Colors.sharedInstance.purple.cgColor
        vabPercentCircle.circle(at: middleView.center, size: (middleView.frame.height / 2) - 10, animation: true)
        
        totalPercentCircle = ShapeLayers()
        totalPercentCircle.strokeColor = Colors.sharedInstance.purple.cgColor
        totalPercentCircle.circle(at: rightView.center, size: (rightView.frame.height / 2) - 10, animation: true)
        
        view.layer.addSublayer(sickPercentCircle)
        view.layer.addSublayer(vabPercentCircle)
        view.layer.addSublayer(totalPercentCircle)
        
        animateCircles()
    }
    
    func animateCircles(month: Int = 0, force: Bool = false) {
        let calendar = Calendar(identifier: .gregorian)
        
        let thisDate = Date()
        let date = calendar.date(byAdding: .month, value: -month, to: thisDate)
        
        var interval = calendar.dateInterval(of: .month, for: thisDate)
        if let date = date {
            interval = calendar.dateInterval(of: .month, for: date)
        }
        
        let day = calendar.dateComponents([.day], from: interval!.start, to: interval!.end).day!
        let cgDay = CGFloat(day)
        
        let vab = CGFloat(User.sharedInstance.event.vabCount(section: month, force: force))
        let sick = CGFloat(User.sharedInstance.event.sickCount(section: month, force: force))
        let total = vab + sick
        
        sickPercentCircle.animate(day: cgDay, daysOff: cgDay-total)
        vabPercentCircle.animate(day: cgDay, daysOff: sick)
        totalPercentCircle.animate(day: cgDay, daysOff: vab)
        
        sickPercentLabel.animate(to: CGFloat(1) - (total/cgDay), with: "Närvaro")
        vabPercentLabel.animate(to: sick/cgDay, with: "Sjuk")
        totalPercentLabel.animate(to: vab/cgDay, with: "Vab")
    }
}
