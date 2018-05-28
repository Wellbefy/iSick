//
//  SetUpTFs.swift
//  WellbefySjukskrivning
//
//  Created by Dennis Galvén on 2018-01-25.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation
import UIKit

extension LogInRegisterVC {
    func setUpTFs() {
        userEmailTF.delegate = self
        userEmailTF.tag = 0
        userEmailTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        passwordTF.delegate = self
        passwordTF.tag = 1
        passwordTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        mailTF.delegate = self
        mailTF.tag = 4
        mailTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        repeatPasswordTF.font = UIFont(name: "Raleway", size: 17)
        repeatPasswordTF.placeholder = "återupprepa lösenord"
        repeatPasswordTF.borderStyle = .roundedRect
        repeatPasswordTF.keyboardType = .default
        repeatPasswordTF.returnKeyType = .next
        repeatPasswordTF.autocorrectionType = .no
        repeatPasswordTF.autocapitalizationType = .none
        repeatPasswordTF.delegate = self
        repeatPasswordTF.tag = 2
        repeatPasswordTF.isSecureTextEntry = true
        repeatPasswordTF.isHidden = true
        repeatPasswordTF.addTarget(self, action: #selector(textFieldDidChange(_: )), for: .editingChanged)
        
        nameTF.font = UIFont(name: "Raleway", size: 17)
        nameTF.placeholder = "för-& efternamn"
        nameTF.borderStyle = .roundedRect
        nameTF.keyboardType = .default
        nameTF.returnKeyType = .next
        nameTF.autocapitalizationType = .words
        nameTF.autocorrectionType = .no
        nameTF.delegate = self
        nameTF.tag = 3
        nameTF.isHidden = true
        nameTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        mailTF.font = UIFont(name: "Raleway", size: 17)
        mailTF.placeholder = "mail till sjukansvarig"
        mailTF.borderStyle = .roundedRect
        mailTF.keyboardType = .emailAddress
        mailTF.autocorrectionType = .no
        mailTF.autocapitalizationType = .none
        mailTF.isHidden = true
        mailTF.returnKeyType = .join
        
        view.addSubview(repeatPasswordTF)
        view.addSubview(nameTF)
        view.addSubview(mailTF)
        
        repeatPasswordTF.translatesAutoresizingMaskIntoConstraints = false
        [
            repeatPasswordTF.topAnchor.constraint(equalTo: passwordTF.topAnchor, constant: 40),
            repeatPasswordTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            repeatPasswordTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            repeatPasswordTF.heightAnchor.constraint(equalToConstant: 0)
            ].forEach{ $0.isActive = true }
        
        nameTF.translatesAutoresizingMaskIntoConstraints = false
        [
            nameTF.topAnchor.constraint(equalTo: repeatPasswordTF.topAnchor, constant: 40),
            nameTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            nameTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            nameTF.heightAnchor.constraint(equalToConstant: 0)
            ].forEach{ $0.isActive = true }
        
        mailTF.translatesAutoresizingMaskIntoConstraints = false
        [
            mailTF.topAnchor.constraint(equalTo: nameTF.topAnchor, constant: 40),
            mailTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            mailTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            mailTF.heightAnchor.constraint(equalToConstant: 0)
            ].forEach{ $0.isActive = true }
    }
}
