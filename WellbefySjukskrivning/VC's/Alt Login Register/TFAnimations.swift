//
//  TFAnimations.swift
//  WellbefySjukskrivning
//
//  Created by Dennis Galvén on 2018-01-25.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation
import UIKit

extension LogInRegisterVC {
    func animateRegister(time: TimeInterval) {
        UIView.animate(withDuration: time, animations: {
            if self.orViewHeight.constant == 0 {
                self.orViewHeight.constant = 20
                self.rightLineHeight.constant = 1
                self.leftLineHeight.constant = 1
                self.doneButtonTrailing.constant = 10
                self.forgotButtonLeading.constant = 10
                self.registerButtonLeading.constant = 10
            } else {
                self.orViewHeight.constant = 0
                self.rightLineHeight.constant = 0
                self.leftLineHeight.constant = 0
                self.doneButtonTrailing.constant = 0 - self.doneButton.frame.size.width
                self.forgotButtonLeading.constant = 0 - self.forgotPasswordButton.frame.size.width
                self.registerButtonLeading.constant = 20 + self.registerButton.frame.size.width
            }
            self.view.layoutIfNeeded()
        }, completion: { _ in
            if self.orViewHeight.constant == 0 {
                self.animateTF()
            }
        })
    }
    
    func animateTF() {
        repeatPasswordTF.isHidden = false
        nameTF.isHidden = false
        mailTF.isHidden = false
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.repeatPasswordTF.constraints.forEach { (constraint) in
                if constraint.firstAttribute == .height {
                    if constraint.constant == 0 {
                        constraint.constant = 30
                    } else {
                        constraint.constant = 0
                    }
                }
            }
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        
        UIView.animate(withDuration: 0.5, delay: 0.25, options: .curveEaseInOut, animations: {
            self.nameTF.constraints.forEach { (constraint) in
                if constraint.firstAttribute == .height {
                    if constraint.constant == 0 {
                        constraint.constant = 30
                    } else {
                        constraint.constant = 0
                    }
                }
            }
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseInOut, animations: {
            self.mailTF.constraints.forEach { (constraint) in
                if constraint.firstAttribute == .height {
                    if constraint.constant == 0 {
                        constraint.constant = 30
                    } else {
                        constraint.constant = 0
                    }
                }
            }
            self.registerDoneButton.trailingAnchor.constraint(equalTo: self.mailTF.trailingAnchor, constant: 0).isActive = true
            self.registerBackButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
            
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
