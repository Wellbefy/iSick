//
//  ShapleLayers.swift
//  WellbefySjukskrivning
//
//  Created by Dennis Galvén on 2018-01-12.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation
import UIKit

class ShapeLayers: CAShapeLayer {
    private let pi = CGFloat.pi
    
    func circle(at position: CGPoint, size: CGFloat, animation: Bool) {
        let circlePath = UIBezierPath(arcCenter: position, radius: size, startAngle: -pi / 2, endAngle: ((2 * pi) - (pi / 2)), clockwise: true)
        
        self.path = circlePath.cgPath
        
        self.fillColor = UIColor.clear.cgColor
        
        
        if animation {
//            self.strokeColor = Colors().lightGreen.cgColor
//            self.lineCap = kCALineCapRound
            self.strokeEnd = 0
            self.lineWidth = 8
        } else {
            self.strokeEnd = 1
            self.lineWidth = 10
//            self.strokeColor = Colors().darkGrayAlpha.cgColor
        }
    }
    
    func animate(day: CGFloat, daysOff: CGFloat) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 1
        
        let value = daysOff / day
        animation.toValue = value
        
        animation.fillMode = kCAFillModeForwards
        
        animation.isRemovedOnCompletion = true
        animation.isRemovedOnCompletion = false
    
        self.add(animation, forKey: nil)
        debugPrint(self.strokeEnd)
    }
}
