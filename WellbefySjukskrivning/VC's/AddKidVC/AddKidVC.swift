//
//  addKidVC.swift
//  WellbefySjukskrivning
//
//  Created by Dennis Galvén on 2018-01-11.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class AddKidVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTF: CheckMarkTextField!
    @IBOutlet weak var prsnrTF: CheckMarkTextField!
    @IBOutlet weak var emailTF: CheckMarkTextField!
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var bottomAnchor: NSLayoutConstraint!
    
    var deleteBottom: NSLayoutConstraint?
    var doneBottom: NSLayoutConstraint?
    var addedLine = false
    
    var number: Int?
    var fromReport = false
    
    let checkPersonNummer = CheckPersonNummer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.isEnabled = false

        checkForEdit()
        addKeyBoardObserver()
    }
    
    //Checks if this is an edit case or a new addition
    private func checkForEdit() {
        if let position = number {
            let editKid = User.sharedInstance.kids[position]
            nameTF.text = editKid.name
            prsnrTF.text = editKid.personNummer
            emailTF.text = editKid.email
            
            deleteButton.isHidden = false
            
            checkMarks()
        } else {
            deleteButton.isHidden = true
        }
    }
    
    private func checkMarks() {
        nameTF.isCorrect(correct: nameTF.text!.contains(" "))
        prsnrTF.isCorrect(correct: checkPersonNummer.checkPersonNr(nr: prsnrTF.text!))
        emailTF.isCorrect(correct: emailTF.text!.contains("@") && emailTF.text!.contains("."))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func checkFields(_ sender: Any) {
        
        checkMarks()
        
        //Removes empty spaces from user input
        prsnrTF.text = prsnrTF.text?.replacingOccurrences(of: " ", with: "")
        
        //Adds dash into input after 6th letter
        if !addedLine {
            if prsnrTF.text!.count == 6 {
                prsnrTF.text = prsnrTF.text! + "-"
                addedLine = true
            }
        } else {
            addedLine = prsnrTF.text!.contains("-")
        }
        
        doneButton.isEnabled = !nameTF.text!.isEmpty &&
                            !emailTF.text!.isEmpty &&
                            checkPersonNummer.checkPersonNr(nr: prsnrTF.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTF:
            prsnrTF.becomeFirstResponder()
            break
        case prsnrTF:
            emailTF.becomeFirstResponder()
            break
        case emailTF:
            view.endEditing(true)
            break
        default:
            break
        }
        
        return true
    }
    
    @IBAction func buttonClick(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            dismiss()
        case 1:
            deleteKid {
                self.dismiss()
            }
        case 2:
            upload {
                self.dismiss()
            }
        default:
            return
        }
    }
    
    private func upload(completion: @escaping () -> ()) {
        let kid = Kid()
        kid.name = nameTF.text
        kid.personNummer = prsnrTF.text
        kid.email = emailTF.text
        
        let database = FBDatabase()
        database.addKid(kid: kid)
        
        if number == nil {
            kid.isSick = fromReport
            User.sharedInstance.kids.append(kid)
        } else {
            database.removeKid(kid: User.sharedInstance.kids[number!])
            User.sharedInstance.kids[number!] = kid
        }
        
        completion()
    }
    
    private func deleteKid(completion: @escaping () -> ()) {
        if let position = number {
            let kid = User.sharedInstance.kids[position]
            let alertController = Alertcontroller()
            self.present(alertController.twoAction(title: "Varning", message: "Detta kommer permanent radera \(kid.name!). Vill du fortsätta?", completion: { OK in
                if OK {
                    let dataBase = FBDatabase()
                    dataBase.removeKid(kid: kid)
                    User.sharedInstance.kids.remove(at: position)
                    completion()
                }
            }), animated: true, completion: nil)
        }
    }
    
    private func dismiss() {
        let dataBase = FBDatabase()
        dataBase.sendNotification()
        number = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
