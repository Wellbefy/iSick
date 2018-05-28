//
//  RegisterVC.swift
//  WellbefySjukskrivning
//
//  Created by Dennis Galvén on 2018-01-09.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailTF: CheckMarkTextField!
    @IBOutlet weak var passwordTF: CheckMarkTextField!
    
    @IBOutlet weak var repeatPasswordTF: CheckMarkTextField!
    @IBOutlet weak var repeatPTFHeight: NSLayoutConstraint!
    
    @IBOutlet weak var nameTF: CheckMarkTextField!
    @IBOutlet weak var nameTFHeight: NSLayoutConstraint!
    
    @IBOutlet weak var mailToEmployeerTF: CheckMarkTextField!
    @IBOutlet weak var mailToEmployeerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var newUser = false
    
    let auth = FBAuth()
    
    let alertController = Alertcontroller()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneButton.layer.cornerRadius = 10
        doneButton.isEnabled = false
        
        repeatPTFHeight.constant = 0
        nameTFHeight.constant = 0
        mailToEmployeerHeight.constant = 0
        
        repeatPasswordTF.isHidden = true
        mailToEmployeer.isHidden = true
        nameTF.isHidden = true
        
        activityIndicator.stopAnimating()
        
        newUser = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //shows additional fields thru animation
    private func animateRepeat() {
        newUser = true
        UIView.animate(withDuration: 1, animations: {
            self.nameTFHeight.constant = 30
            self.repeatPTFHeight.constant = 30
            self.mailToEmployeerHeight.constant = 30
            self.view.layoutIfNeeded()
        }, completion: {_ in
            self.repeatPasswordTF.becomeFirstResponder()
        })
    }
    
    //checks user inputs
    @IBAction func checkTFs(_ sender: UITextField) {
        //Displays checkmark if textfields are properly filled
        emailTF.isCorrect(correct: emailTF.text!.contains("@") && emailTF.text!.contains("."))
        passwordTF.isCorrect(correct: passwordTF.text!.count >= 6)
        repeatPasswordTF.isCorrect(correct: repeatPasswordTF.text! == passwordTF.text! && repeatPasswordTF.text!.count >= 6)
        nameTF.isCorrect(correct: nameTF.text!.contains(" "))
        mailToEmployeerTF.isCorrect(correct: mailToEmployeerTF.text!.contains("@") && mailToEmployeerTF.text!.contains("."))
        
        //Enables doneButton
        if !newUser {
            doneButton.isEnabled = emailTF.text!.contains("@") && passwordTF.text!.count > 5
        } else {
            doneButton.isEnabled = !emailTF.text!.isEmpty &&
                                !passwordTF.text!.isEmpty &&
                                !repeatPasswordTF.text!.isEmpty &&
                                !nameTF.text!.isEmpty &&
                                !mailToEmployeerTF.text!.isEmpty
        }
    }
    
    //commands for execution of return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTF:
            passwordTF.becomeFirstResponder()
            break
        case passwordTF:
            done()
            break
        case repeatPasswordTF:
            nameTF.becomeFirstResponder()
            break
        case nameTF:
            done()
            break
        default:
            break
        }
        return true
    }
    
    private func done() {
        if !newUser {
            checkUser()
        } else {
            createAccount()
        }
    }
    
    //attemps to log in user. If user is new UI displays additional fields
    private func checkUser() {
        loading(loading: true)
        
        doneButton.isEnabled = false
        
        auth.tryToLogin(email: emailTF.text!, password: passwordTF.text!, completion: {doesntExist, error in
            self.loading(loading: false)
            if error != nil {
                if doesntExist {
                    self.animateRepeat()
                } else {
                    self.present(self.alertController.oneAction(message: error!.localizedDescription), animated: true, completion: nil)
                }
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    //creates user account
    private func createAccount() {
        loading(loading: true)
        
        if passwordTF.text != repeatPasswordTF.text {
            loading(loading: false)
            self.present(alertController.oneAction(message: "Lösenorden matchar inte. Försök igen."), animated: true, completion: nil)
            repeatPasswordTF.text = ""
        } else {
            auth.createUser(email: emailTF.text!, password: repeatPasswordTF.text!, name: nameTF.text!, mailToEmployeer: mailToEmployeerTF.text!, completion: {error in
                self.loading(loading: false)
                
                if error != nil {
                    self.present(self.alertController.oneAction(message: error!.localizedDescription), animated: true, completion: nil)
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
    
    @IBAction func doneClick(_ sender: Any) {
        done()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //animated loading wheel
    private func loading(loading: Bool) {
        if loading {
            emailTF.isEnabled = false
            passwordTF.isEnabled = false
            repeatPasswordTF.isEnabled = false
            nameTF.isEnabled = false
            mailToEmployeerTF.isEnabled = false
            
            doneButton.isHidden = true
            
            activityIndicator.startAnimating()
        } else {
            emailTF.isEnabled = true
            passwordTF.isEnabled = true
            repeatPasswordTF.isEnabled = true
            nameTF.isEnabled = true
            mailToEmployeerTF.isEnabled = true
            
            doneButton.isHidden = false
            
            activityIndicator.stopAnimating()
        }
    }
}
