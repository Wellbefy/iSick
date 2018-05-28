//
//  PercentAnimationLabel.swift
//  WellbefySjukskrivning
//
//  Created by Dennis Galvén on 2018-01-15.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class PercentAnimationLabel: UILabel {
    var currentPercent = 0
    
    func animate(to value: CGFloat, with text: String) {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 1
        let percent: CGFloat = value * CGFloat(100)
        let intPercent = Int(percent.rounded())
        let newValue = fabs(CGFloat(currentPercent) - percent)
        
        let interval = TimeInterval(CGFloat(1)/newValue)
        
        Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: { timer in
            if self.currentPercent < 0 {
                self.currentPercent = 0
            }
            
            if self.currentPercent < intPercent {
                self.currentPercent += 1
            } else {
                self.currentPercent -= 1
            }
            
            self.text = "\(text):\n\(self.currentPercent)%"
            
            if self.currentPercent == intPercent {
                self.currentPercent = intPercent
                self.text = "\(text):\n\(numberFormatter.string(for: percent)!)%"
                timer.invalidate()
            }
        })
    }
}
