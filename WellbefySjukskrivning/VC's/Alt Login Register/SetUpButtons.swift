//
//  SetUpButtons.swift
//  WellbefySjukskrivning
//
//  Created by Dennis Galvén on 2018-01-29.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation
import UIKit

extension LogInRegisterVC {
    func setUpButtons() {
        registerDoneButton.removeFromSuperview()
        registerBackButton.removeFromSuperview()
        
        registerDoneButton.titleLabel?.font = UIFont(name: "Raleway", size: 17)
        registerDoneButton.setTitle("Klar", for: .normal)
        registerDoneButton.setTitleColor(Colors.sharedInstance.green, for: .normal)
        registerDoneButton.setTitleColor(Colors.sharedInstance.greenAlpha, for: .highlighted)
        registerDoneButton.backgroundColor = UIColor.clear
        registerDoneButton.tag = 2
        registerDoneButton.addTarget(self, action: #selector(click(_:)), for: .touchDown)
        
        registerBackButton.titleLabel?.font = UIFont(name: "Raleway", size: 17)
        registerBackButton.setTitle("Tillbaka", for: .normal)
        registerBackButton.setTitleColor(Colors.sharedInstance.darkGray, for: .normal)
        registerBackButton.setTitleColor(Colors.sharedInstance.darkGrayAlpha, for: .highlighted)
        registerBackButton.backgroundColor = UIColor.clear
        registerBackButton.tag = 3
        registerBackButton.addTarget(self, action: #selector(click(_:)), for: .touchDown)
        
        view.addSubview(registerDoneButton)
        view.addSubview(registerBackButton)
        
        registerDoneButton.translatesAutoresizingMaskIntoConstraints = false
        [
            registerDoneButton.topAnchor.constraint(equalTo: mailTF.topAnchor, constant: 40),
            registerDoneButton.trailingAnchor.constraint(equalTo: mailTF.trailingAnchor, constant: 70),
            registerDoneButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
            registerDoneButton.heightAnchor.constraint(lessThanOrEqualToConstant: 30)
            ].forEach { $0.isActive = true }
        
        registerBackButton.translatesAutoresizingMaskIntoConstraints = false
        [
            registerBackButton.topAnchor.constraint(equalTo: mailTF.topAnchor, constant: 40),
            registerBackButton.leadingAnchor.constraint(equalTo: mailTF.leadingAnchor, constant: -90),
            registerBackButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 70),
            registerBackButton.heightAnchor.constraint(lessThanOrEqualToConstant: 30)
            ].forEach { $0.isActive = true }
        
        self.view.layoutIfNeeded()
    }
}
