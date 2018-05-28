//
//  SendMailVC.swift
//  WellbefySjukskrivning
//
//  Created by Dennis Galvén on 2018-01-15.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class SendMailVC: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var mailAdressLabel: UILabel!
    @IBOutlet weak var pageDisplay: UIPageControl!
    @IBOutlet weak var pageControlHeight: NSLayoutConstraint!
    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var bottomLine: UIView!
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    let dataSource = CollectionViewDataSource()
    
    let colors = Colors()
    let texts = MailText()
    
    var mailTexts = [String]()
    
    let email = Email()
    
    var vab = false
    
    let alertController = Alertcontroller()
    
    let loadingLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomView.layer.cornerRadius = 10
        
        mailAdressLabel.text = "Skicka till:\t\(User.sharedInstance.email!)"
        
        if !vab {
            mailTexts.append(texts.swedishSick())
            pageControlHeight.constant = 0
        } else {
            mailTexts.append(texts.swedishVab())
            for kid in User.sharedInstance.kids {
                if kid.isSick {
                    self.mailAdressLabel.text = self.mailAdressLabel.text! + "\n\t\t\t\(kid.email!)"
                    mailTexts.append(texts.swedishSickKid(named: kid.name!, personNumber: kid.personNummer!))
                }
            }
        }
        
        topLine.backgroundColor = colors.blueGray
        bottomLine.backgroundColor = colors.blueGray
        
        dataSource.texts = mailTexts
        
        collectionView.dataSource = dataSource
        collectionView.delegate = dataSource
        
        pageDisplay.numberOfPages = mailTexts.count
        
        NotificationCenter.default.addObserver(self, selector: #selector(updatePage), name: NSNotification.Name("newpage"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadingLabel.font = UIFont.init(name: "Raleway", size: 20)
        loadingLabel.textColor = colors.green
        loadingLabel.text = "Skickar"
        loadingLabel.textAlignment = .center
        view.addSubview(loadingLabel)
        
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        [
            loadingLabel.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor),
            loadingLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor),
            loadingLabel.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor),
            loadingLabel.topAnchor.constraint(equalTo: bottomView.topAnchor)
            ].forEach{ $0.isActive = true }
        
        loadingLabel.isHidden = true
    }
    
    //updates pagecontrol
    @objc func updatePage(notification: NSNotification) {
        let page = notification.object as! Int
        pageDisplay.currentPage = page
    }
    
    //Sending mail to employeer
    private func sendMail(completion: @escaping () -> ()) {
        let body = mailTexts.first ?? ""
        mailTexts.removeFirst()
        
        email.sendMailUser(body: body, vab: vab, completion: { (error) in
            if error != nil {
                self.presentAlert(to: User.sharedInstance.email!, kid: false)
                return
            }
            if self.vab {
                self.sendSchoolMail {
                    completion()
                }
            } else {
                completion()
            }
        })
    }
    
    //Sending mail to school
    private func sendSchoolMail(completion: @escaping () -> ()) {
        var counter = 0
        for kid in User.sharedInstance.kids {
            if kid.isSick {
                let body = mailTexts.first ?? ""
                mailTexts.removeFirst()
                
                email.sendEmailSchool(to: [kid.email!], body: body, completion: { (error) in
                    if error != nil {
                        self.presentAlert(to: kid.email!, kid: true)
                    }
                })
            }
            counter += 1
            
            if counter == User.sharedInstance.kids.count {
                completion()
            }
        }
    }
    
    //Uploads event to database
    private func uploadToFB(reportedToFk: Bool = false) {
        let database = FBDatabase()
        if vab {
            for kid in User.sharedInstance.kids {
                if kid.isSick {
                    database.uploadEvent(name: kid.name!, vab: true, reported: reportedToFk)
                }
            }
        }
        
        database.uploadEvent(name: User.sharedInstance.name!, vab: vab, reported: nil)
    }
    
    private func createPushNotification() {
        PushNotifications.sharedInstance.createPush()
    }
    
    //Cancel or send button clicks
    @IBAction func sendClick(_ sender: UIButton) {
        
        mailTexts = (collectionView.dataSource as! CollectionViewDataSource).texts
        
        let date = Date()

        switch sender.tag {
        case 0: //cancel click
            self.dismiss(animated: true, completion: nil)
            return
        case 1: //send click
            if User.sharedInstance.alreadySick(date: date) {
                self.present(alertController.twoAction(title: "Redan anmält", message: "Du har redan anmält frånvaro för idag. Vill du skicka igen?", completion: { OK in
                    if OK {
                        self.sendButton.isHidden = true
                        self.backButton.isHidden = true
                        self.sendToFK()
                    }
                }), animated: true, completion: nil)
            } else {
                sendToFK()
            }
            return
        default:
            return
        }
    }
    
    //excecutes all send functions
    func send(reported: Bool = false) {
        sendLoading()
        let queue = DispatchQueue.global(qos: .userInitiated)
        queue.async {
            self.uploadToFB(reportedToFk: reported)
            self.createPushNotification()
            self.sendMail {
                self.stopLoading(finished: true)
            }
        }
    }
    
    func sendToFK() {
        if !vab {
            send()
            return
        }
        
        self.present(alertController.twoAction(title: "Försäkringskassan", message: "Vill du anmäla VAB till Försäkringskassan?", completion: { OK in
            if OK {
                DispatchQueue.main.async {
                    self.sendButton.isHidden = true
                    self.backButton.isHidden = true
                }
                self.sendSms(parent: User.sharedInstance.personNr, kid: User.sharedInstance.getVabNr()[0])
            } else {
                self.send()
            }
        }), animated: true, completion: nil)
    }
    
    //presents alertcontroller if mail couldn't be sent
    private func presentAlert(to mail: String, kid: Bool) {
        stopLoading(finished: false)
        self.present(alertController.twoAction(title: "Oj!", message: "Kunde inte skicka mail till \(mail). Försöka igen?", completion: { OK in
            if OK {
               self.sendToFK()
            }
        }), animated: true, completion: nil)
    }
    
    //Starts loading anomation
    private func sendLoading() {
        DispatchQueue.main.async {
            self.loadingLabel.isHidden = false
            self.bottomView.isHidden = true
            self.loadingLabel.text = "Skickar"
            
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: {timer in
                switch self.loadingLabel.text! {
                case "Skickar":
                    self.loadingLabel.text = "Skickar."
                    break
                case "Skickar.":
                    self.loadingLabel.text = "Skickar.."
                    break
                case "Skickar..":
                    self.loadingLabel.text = "Skickar..."
                    break
                case "Klart!":
                    timer.invalidate()
                    break
                default:
                    self.loadingLabel.text = "Skickar"
                    break
                }
            })
        }
    }
    
    @IBAction func editClick(_ sender: Any) {
        let indexPath = IndexPath(item: pageDisplay.currentPage, section: 0)
        
        (collectionView.cellForItem(at: indexPath) as! MailCell).editText()
    }
    
    
    
    //stops loading anomation and dismissen viewcontroller
    private func stopLoading(finished: Bool) {
        DispatchQueue.main.async {
            if finished {
                self.loadingLabel.text = "Klart!"
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { _ in
                    self.loadingLabel.isHidden = true
                    self.doneDismiss()
                })
            } else {
                self.loadingLabel.isHidden = true
                self.bottomView.isHidden = false
            }
        }
    }
    
    //dismisses viewcontroller
    private func doneDismiss() {
        self.dismiss(animated: true, completion: {
            NotificationCenter.default.removeObserver(self)
            User.sharedInstance.resetKids()
        })
    }
}
