//
//  ResetPassword.swift
//  WellbefySjukskrivning
//
//  Created by Dennis Galvén on 2018-02-08.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation
import UIKit

extension LogInRegisterVC {
    
    func presentResetPassword() {
        addBlurView()
        
        resetPasswordTF = CheckMarkTextField()
        if let resetPasswordTF = resetPasswordTF {
            resetPasswordTF.font = UIFont(name: "Raleway", size: 17)
            resetPasswordTF.placeholder = "email för återställning"
            resetPasswordTF.borderStyle = .roundedRect
            resetPasswordTF.keyboardType = .emailAddress
            resetPasswordTF.autocorrectionType = .no
            resetPasswordTF.autocapitalizationType = .none
            resetPasswordTF.returnKeyType = .done
            resetPasswordTF.delegate = self
            resetPasswordTF.tag = 5
            
            blurView.contentView.addSubview(resetPasswordTF)
            
            resetPasswordTF.translatesAutoresizingMaskIntoConstraints = false
            [
                resetPasswordTF.heightAnchor.constraint(equalToConstant: 30),
                resetPasswordTF.leadingAnchor.constraint(equalTo: blurView.leadingAnchor, constant: 10),
                resetPasswordTF.trailingAnchor.constraint(equalTo: blurView.trailingAnchor, constant: -10),
                resetPasswordTF.centerYAnchor.constraint(equalTo: view.centerYAnchor)
                ].forEach {$0.isActive = true}
            
            resetPasswordTF.becomeFirstResponder()
        }
        
        resetButtonDone = UIButton()
        if let resetbuttonDone = resetButtonDone {
            resetbuttonDone.setTitle("Skicka", for: .normal)
            resetbuttonDone.setTitleColor(Colors.sharedInstance.green, for: .normal)
            resetbuttonDone.setTitleColor(Colors.sharedInstance.greenAlpha, for: .highlighted)
            resetbuttonDone.titleLabel?.font = UIFont(name: "Raleway", size: 17)
            resetbuttonDone.tag = 6
            resetbuttonDone.addTarget(self, action: #selector(click(_:)), for: .touchDown)
            blurView.contentView.addSubview(resetbuttonDone)
            
            resetbuttonDone.translatesAutoresizingMaskIntoConstraints = false
            [
                resetbuttonDone.topAnchor.constraint(equalTo: resetPasswordTF!.bottomAnchor, constant: 10),
                resetbuttonDone.trailingAnchor.constraint(equalTo: blurView.trailingAnchor, constant: -10),
                resetbuttonDone.heightAnchor.constraint(equalToConstant: 30),
                resetbuttonDone.widthAnchor.constraint(greaterThanOrEqualToConstant: 50)
                ].forEach {$0.isActive = true}
        }
        
        resetButtonBack = UIButton()
        if let resetButtonBack = resetButtonBack {
            resetButtonBack.setTitle("Tillbaka", for: .normal)
            resetButtonBack.setTitleColor(Colors.sharedInstance.green, for: .normal)
            resetButtonBack.setTitleColor(Colors.sharedInstance.greenAlpha, for: .highlighted)
            resetButtonBack.titleLabel?.font = UIFont(name: "Raleway", size: 17)
            resetButtonBack.tag = 5
            resetButtonBack.addTarget(self, action: #selector(click(_:)), for: .touchDown)
            blurView.contentView.addSubview(resetButtonBack)
            
            resetButtonBack.translatesAutoresizingMaskIntoConstraints = false
            [
                resetButtonBack.topAnchor.constraint(equalTo: resetPasswordTF!.bottomAnchor, constant: 10),
                resetButtonBack.leadingAnchor.constraint(equalTo: blurView.leadingAnchor, constant: 10),
                resetButtonBack.heightAnchor.constraint(equalToConstant: 30),
                resetButtonBack.widthAnchor.constraint(greaterThanOrEqualToConstant: 50)
                ].forEach {$0.isActive = true}
        }
    }
    
    func removeAllResetViews() {
        if let resetPasswordTF = resetPasswordTF {
            resetPasswordTF.removeFromSuperview()
        }
        
        if let resetButtonDone = resetButtonDone {
            resetButtonDone.removeFromSuperview()
        }
        
        if let resetButtonBack = resetButtonBack {
            resetButtonBack.removeFromSuperview()
        }
        
        blurView.removeFromSuperview()
    }
    
    func resetPassword() {
        if let resetPasswordTF = resetPasswordTF {
            self.resetLoading()
            let auth = FBAuth()
            auth.passwordReset(email: resetPasswordTF.text!, completion: { error in
                self.resetStopLoading()
                if let error = error {
                    self.presentErrorDialog(error: error.localizedDescription)
                } else {
                    self.presentSuccessDialog()
                }
            })
        }
    }
    
    func presentSuccessDialog() {
        let message = "Länk för att återställa lösenordet är nu skickad till: \(resetPasswordTF!.text!)"
        let success = alert.sucsessDialog(message: message, completion: {
            self.removeAllResetViews()
        })
        
        self.present(success, animated: true, completion: nil)
    }
    
    func presentErrorDialog(error: String) {
        self.present(alert.oneAction(message: error), animated: true, completion: nil)
    }
    
    func resetLoading() {
        setUpActivityIndicator()
        
        blurView.contentView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        [
            activityIndicator.topAnchor.constraint(equalTo: resetPasswordTF!.bottomAnchor, constant: 10),
            activityIndicator.trailingAnchor.constraint(equalTo: blurView.trailingAnchor, constant: -10),
            activityIndicator.heightAnchor.constraint(equalToConstant: 30),
            activityIndicator.widthAnchor.constraint(equalToConstant: 50)
            ].forEach {$0.isActive = true}
        
        if let resetButtonDone = resetButtonDone {
            resetButtonDone.isHidden = true
        }
        
        if let resetButtonBack = resetButtonBack {
            resetButtonBack.isHidden = true
        }
    }
    
    func resetStopLoading() {
        activityIndicator.removeFromSuperview()
        
        if let resetButtonDone = resetButtonDone {
            resetButtonDone.isHidden = false
        }
        
        if let resetButtonBack = resetButtonBack {
            resetButtonBack.isHidden = false
        }
    }
}
