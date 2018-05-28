//
//  TFDelegate.swift
//  WellbefySjukskrivning
//
//  Created by Dennis Galvén on 2018-01-25.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation
import UIKit

extension LogInRegisterVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            passwordTF.becomeFirstResponder()
            break
        case 1:
            if login {
                view.endEditing(true)
                //login
            } else {
                nameTF.becomeFirstResponder()
            }
            break
        case 2:
            nameTF.becomeFirstResponder()
            break
        case 3:
            mailTF.becomeFirstResponder()
        case 4:
            view.endEditing(true)
            //registrera
            break
        case 5:
            debugPrint("återställ")
            break
        default:
            break
        }
        return true
    }
    
    @objc func textFieldDidChange(_ textField: CheckMarkTextField){
        switch textField.tag {
        case 0:
            let correct = textField.text!.contains("@") && textField.text!.contains(".")
            textField.isCorrect(correct: correct)
            break
        case 1:
            textField.isCorrect(correct: textField.text!.count >= 6)
            break
        case 2:
            let correct = textField.text! == passwordTF.text!
            textField.isCorrect(correct: correct)
            break
        case 3:
            textField.isCorrect(correct: !textField.text!.isEmpty)
            break
        case 4:
            let correct = textField.text!.contains("@") && textField.text!.contains(".")
            textField.isCorrect(correct: correct)
            break
        default:
            return
        }
    }
}
