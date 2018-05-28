//
//  ReportVC.swift
//  WellbefySjukskrivning
//
//  Created by Dennis Galvén on 2018-01-09.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit
import Crashlytics

class ReportVC: UIViewController, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var personNrTF: CheckMarkTextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var vabSwitch: UISwitch!
    @IBOutlet weak var vabTV: UITableView!
    @IBOutlet weak var vabTVHeight: NSLayoutConstraint!
    
    var addedLine = false
    
    let dataSource = KTVDataSource()
    
    let checkPersonNummer = CheckPersonNummer()
    
    var toAddKid = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkMark()
        observeNotifications()
    }
    
    private func observeNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(kidsDone(_:)), name: NSNotification.Name("downloadDone"), object: nil)
    }
    
    private func setUp() {
        observeNotifications()
        vabSwitch.isOn = false
        vabTVHeight.constant = 0
        
        personNrTF.text = User.sharedInstance.personNr
        
        vabTV.dataSource = dataSource
        vabTV.allowsSelection = false
        vabTV.isScrollEnabled = false
        
        checkMark()
    }
    
    private func checkMark() {
        doneButton.isEnabled = !User.sharedInstance.personNr.isEmpty
        personNrTF.text = User.sharedInstance.personNr
        
        if checkPersonNummer.checkPersonNr(nr: personNrTF.text!) {
            personNrTF.isCorrect(correct: true)
        } else {
            personNrTF.isCorrect(correct: false)
        }
    }
    
    @objc func kidsDone(_ notification: NSNotification) {
        nameLabel.text = User.sharedInstance.name
        vabTV.reloadData()
        
        if toAddKid && !User.sharedInstance.kids.isEmpty {
            let cell = KidCell()
            vabTVHeight.constant = cell.getHeight() * CGFloat(User.sharedInstance.kids.count)
            toAddKid = false
        }
    }
    
    //displays tableview tru animation
    private func animateTV(to value: CGFloat) {
        UIView.animate(withDuration: 1, animations: {
            self.vabTVHeight.constant = value
            self.view.layoutIfNeeded()
        }, completion: {_ in
            
        })
    }
    
    func segueToAddKids() {
        toAddKid = true
        performSegue(withIdentifier: "tokidsfromreport", sender: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func personNrEdit(_ sender: Any) {
        //Removes empty spaces from user input
        personNrTF.text = personNrTF.text?.replacingOccurrences(of: " ", with: "")
        
        //Adds dash into input after 6th letter
        if !addedLine {
            if personNrTF.text!.count == 6 {
                personNrTF.text = personNrTF.text! + "-"
                addedLine = true
            }
        } else {
            addedLine = personNrTF.text!.contains("-")
        }
        
        //Stops user from input above alowed count
        if personNrTF.text!.count > 11 {
            personNrTF.text = String(personNrTF.text!.dropLast())
        }
        
        //Enabled doneButton if personnummer is correct
        doneButton.isEnabled = checkPersonNummer.checkPersonNr(nr: personNrTF.text!)
        personNrTF.isCorrect(correct: checkPersonNummer.checkPersonNr(nr: personNrTF.text!))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
//        if checkPersonNummer.checkPersonNr(nr: personNrTF.text!) {
//           report()
//        }
        return true
    }
    
    @IBAction func vabSwitched(_ sender: Any) {
        vabTV.reloadData()
        
        if User.sharedInstance.kids.isEmpty && vabSwitch.isOn {
            let alert = Alertcontroller()
            self.present(alert.twoAction(title: "Hej!", message: "Vill du lägga till ett barn så vi kan skicka sjukanmälan till skolan också?") { OK in
                if OK {
                   self.segueToAddKids()
                }
            }, animated: true, completion: nil)
            return
        }
        
        let cell = KidCell()
        if vabSwitch.isOn {
            animateTV(to: (cell.getHeight() * CGFloat(User.sharedInstance.kids.count)) + 10)
        } else {
            animateTV(to: 0)
            
            for kid in User.sharedInstance.kids {
                kid.isSick = false
            }
        }
    }
    
    private func report() {
        User.sharedInstance.setPrsNr(to: personNrTF.text!)
        performSegue(withIdentifier: "sendemail", sender: vabSwitch.isOn)
    }
    
    @IBAction func doneClick(_ sender: Any) {
        view.endEditing(true)
        report()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if !toAddKid {
            vabSwitch.isOn = false
            vabTVHeight.constant = 0
            doneButton.isEnabled = false
            
            User.sharedInstance.resetKids()
        }
        //        NotificationCenter.default.removeObserver(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? SendMailVC {
            self.vabTVHeight.constant = 0
            self.vabSwitch.isOn = false
            dest.vab = sender as! Bool
        }
        if let dest2 = segue.destination as? AddKidVC {
            dest2.number = nil
            dest2.fromReport = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
