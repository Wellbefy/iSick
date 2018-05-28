//
//  AddKidKeyboardHandling.swift
//  WellbefySjukskrivning
//
//  Created by Dennis Galvén on 2018-02-08.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation
import UIKit

extension AddKidVC {
    func addKeyBoardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let frame = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            deleteBottom = deleteButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(frame.size.height + 10))
            deleteBottom?.isActive = true
            deleteButton.isHidden = true
            doneBottom = doneButton.bottomAnchor.constraint(equalTo: deleteButton.bottomAnchor, constant: 0)
            doneBottom?.isActive = true
            view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        deleteBottom?.isActive = false
        if number != nil {
            deleteButton.isHidden = false
        }
        doneBottom?.isActive = false
        view.layoutIfNeeded()
    }
    
    func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self)
    }
}
