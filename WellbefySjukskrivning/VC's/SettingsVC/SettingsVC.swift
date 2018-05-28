//
//  SettingsVC.swift
//  WellbefySjukskrivning
//
//  Created by Dennis Galvén on 2018-01-10.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController, UITableViewDelegate, UITextFieldDelegate{
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var changeNameTF: UITextField!
    
    @IBOutlet weak var employerMailLabel: UILabel!
    @IBOutlet weak var editMailTF: UITextField!
    
    @IBOutlet weak var remindMeLabel: UILabel!
    @IBOutlet weak var editRemindMe: UITextField!
    
    
    //TableView outlets and datasource
    @IBOutlet weak var kidTV: UITableView!
    @IBOutlet weak var kidTVHeight: NSLayoutConstraint!
    let dataSource = KidSettingTVDataSource()
    
    let timePicker = TimePicker()
    
    let blur = UIVisualEffectView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.viewController = self
        kidTV.dataSource = dataSource
        kidTV.delegate = dataSource
        
        editMailTF.isHidden = true
        editMailTF.delegate = self
        
        editRemindMe.isHidden = true
        editRemindMe.delegate = self
        
        changeNameTF.isHidden = true
        changeNameTF.delegate = self
//        hideTV()
        timePicker.setup(view: view)
        timePicker.addTarget(self, action: #selector(timechanged), for: .valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Observes local notifications for tableview reload
        NotificationCenter.default.addObserver(self, selector: #selector(kidsDone(_:)), name: NSNotification.Name("downloadDone"), object: nil)
        
        hideTV()
    }
    
    @objc func timechanged(picker: UIDatePicker) {
        PushNotifications.sharedInstance.changePushTime(to: picker.date)
        remindMeLabel.text = "Påminnelse klockan \(PushNotifications.sharedInstance.displayTime()) dagen efter"
        timePicker.updateLabel()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func kidsDone(_ notification: NSNotification) {
        hideTV()
    }
    
    private func hideTV() {
        nameLabel.text = User.sharedInstance.name!
        employerMailLabel.text = User.sharedInstance.email!
        remindMeLabel.text = "Påminnelse klockan \(PushNotifications.sharedInstance.displayTime()) dagen efter"
        if User.sharedInstance.kids.isEmpty {
            kidTVHeight.constant = 0
        } else {
            kidTVHeight.constant = 128
        }
        kidTV.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func editEmail() {
        //Hides and shows proper UI elements
        if editMailTF.isHidden {
            editMailTF.isHidden = false
            employerMailLabel.isHidden = true
            editMailTF.text = employerMailLabel.text
            editMailTF.becomeFirstResponder()
        } else {
            employerMailLabel.text = editMailTF.text
            editMailTF.isHidden = true
            employerMailLabel.isHidden = false
        }
    }
    
    private func changeUserName() {
        if nameLabel.isHidden == false {
            nameLabel.isHidden = true
            changeNameTF.isHidden = false
            changeNameTF.text = nameLabel.text
            changeNameTF.becomeFirstResponder()
        } else {
            changeNameTF.isHidden = true
            nameLabel.isHidden = false
            nameLabel.text = changeNameTF.text
        }
    }
    
    @IBAction func editClick(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            editEmail()
            return
        case 1:
            editRemindMe.inputView = timePicker
            editRemindMe.becomeFirstResponder()
            addBlur(true)
            return
        case 2:
            changeUserName()
            break
        default:
            return
        }
    }
    
    private func addBlur(_ add: Bool) {
        if add {
            blur.effect = UIBlurEffect(style: .dark)
            view.addSubview(blur)
            blur.translatesAutoresizingMaskIntoConstraints = false
            [
                blur.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
                blur.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                blur.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                blur.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                ].forEach {$0.isActive = true}
        } else {
            blur.removeFromSuperview()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let dataBase = FBDatabase()
        //Dismisses keyboard
        view.endEditing(true)
        switch textField.tag {
        case 0:
            editEmail()
            dataBase.updateEmail(email: editMailTF.text!)
            break
        case 2:
            changeUserName()
            dataBase.changeUserName(to: textField.text!)
            break
        default:
            break
        }
        return true
    }
    
    @IBAction func addKidClick(_ sender: UIButton) {
        segueToAddKid(kid: nil)
    }
    
    @IBAction func signOutClick(_ sender: Any) {
        nameLabel.text = ""
        employerMailLabel.text = ""
        let auth = FBAuth()
        auth.signOut()
    }
    
    func segueToAddKid(kid: Int?) {
        performSegue(withIdentifier: "addkid", sender: kid)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! AddKidVC
        dest.number = sender as? Int
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        addBlur(false)
    }
}
