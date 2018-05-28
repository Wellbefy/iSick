//
//  RegisterKeyboardHandling.swift
//  WellbefySjukskrivning
//
//  Created by Dennis Galvén on 2018-02-08.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation
import UIKit

extension LogInRegisterVC {
    func addKeyBoardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let frame = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if !login {
                mailTFBottomAnchor = mailTF.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(frame.size.height + registerDoneButton.frame.size.height + 20))
                mailTFBottomAnchor!.isActive = true
                view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        if let bottom = mailTFBottomAnchor {
            bottom.isActive = false
        }
        view.layoutIfNeeded()
    }
    
    func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self)
    }
}
