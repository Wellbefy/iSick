//
//  LogInRegisterVC.swift
//  WellbefySjukskrivning
//
//  Created by Dennis Galvén on 2018-01-25.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class LogInRegisterVC: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var orViewHeight: NSLayoutConstraint!
    @IBOutlet weak var rightLineHeight: NSLayoutConstraint!
    @IBOutlet weak var leftLineHeight: NSLayoutConstraint!
    @IBOutlet weak var doneButtonTrailing: NSLayoutConstraint!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var registerButtonLeading: NSLayoutConstraint!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var userEmailTF: CheckMarkTextField!
    @IBOutlet weak var passwordTF: CheckMarkTextField!
    
    let repeatPasswordTF = CheckMarkTextField()
    let nameTF = CheckMarkTextField()
    let mailTF = CheckMarkTextField()
    var mailTFBottomAnchor: NSLayoutConstraint?
    let registerDoneButton = UIButton()
    let registerBackButton = UIButton()
    
    let activityIndicator = UIActivityIndicatorView()
    let blurView = UIVisualEffectView()
    let alert = Alertcontroller()
    
    var login = true
    let auth = FBAuth()
    
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var forgotButtonLeading: NSLayoutConstraint!
    
    var resetPasswordTF: CheckMarkTextField?
    var resetButtonDone: UIButton?
    var resetButtonBack: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTFs()
        setUpButtons()
        addKeyBoardObserver()
        
        forgotPasswordButton.setTitleColor(Colors.sharedInstance.purple, for: .normal)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        removeKeyboardObserver()
    }
    
    @IBAction func click(_ sender: UIButton) {
        view.endEditing(true)
        switch sender.tag {
        case 0:
            loading(true)
            logIn()
            break
        case 1:
            titleLabel.text = "Registrera"
            animate(loginAnimation: false)
            break
        case 2:
            loading(true)
            register()
            break
        case 3:
            titleLabel.text = "Logga in"
            animate(loginAnimation: true)
            break
        case 4:
            presentResetPassword()
            break
        case 5:
            removeAllResetViews()
            break
        case 6:
            resetPassword()
            break
        default:
            return
        }
    }
    
    private func logIn() {
        auth.tryToLogin(email: userEmailTF.text!, password: passwordTF.text!, completion: {doesntExist, error in
            if doesntExist {
                self.loading(false)
                let alertBox = self.alert.twoAction(title: "Ojdå", message: "Kunde inte hitta någon användare med den mailadressen. Är du ny här?", completion: { OK in
                    if OK {
                      self.animate(loginAnimation: false)
                    }
                })
                self.present(alertBox, animated: true, completion: nil)
                return
            }
            if let aError = error {
                self.loading(false)
                self.present(self.alert.oneAction(message: aError.localizedDescription), animated: true, completion: nil)
            } else {
                self.loading(false)
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    private func register() {
        if (userEmailTF.correct() && passwordTF.correct() &&
            repeatPasswordTF.correct() && nameTF.correct() && mailTF.correct()) {
            auth.createUser(email: userEmailTF.text!, password: passwordTF.text!, name: nameTF.text!, mailToEmployeer: mailTF.text!, completion: {error in
                if let aError = error {
                    self.loading(false)
                    self.present(self.alert.oneAction(message: aError.localizedDescription), animated: true, completion: nil)
                } else {
                    self.loading(false)
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
    
    private func loading(_ loading: Bool) {
        if loading {
            addBlurView()
            
            setUpActivityIndicator()
            
            blurView.contentView.addSubview(activityIndicator)
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            [
                activityIndicator.centerYAnchor.constraint(equalTo: blurView.centerYAnchor),
                activityIndicator.centerXAnchor.constraint(equalTo: blurView.centerXAnchor),
                activityIndicator.widthAnchor.constraint(equalToConstant: 50),
                activityIndicator.heightAnchor.constraint(equalToConstant: 50)
                ].forEach {$0.isActive = true}
            
        } else {
            activityIndicator.removeFromSuperview()
            blurView.removeFromSuperview()
        }
    }
    
    func addBlurView() {
        blurView.effect = UIBlurEffect(style: .dark)
        view.addSubview(blurView)
        
        blurView.translatesAutoresizingMaskIntoConstraints = false
        [
            blurView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ].forEach {$0.isActive = true}
    }
    
    func setUpActivityIndicator() {
        activityIndicator.startAnimating()
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.color = Colors.sharedInstance.green
    }
    
    private func animate(loginAnimation: Bool) {
        login = loginAnimation
        view.endEditing(true)
        if loginAnimation {
            repeatPasswordTF.text!.removeAll()
            nameTF.text!.removeAll()
            mailTF.text!.removeAll()
            
            repeatPasswordTF.isHidden = true
            nameTF.isHidden = true
            mailTF.isHidden = true
            setUpButtons()
            
            repeatPasswordTF.constraints.forEach {(constraint) in
                if constraint.firstAttribute == .height {
                    constraint.constant = 0
                }
            }
            nameTF.constraints.forEach {(constraint) in
                if constraint.firstAttribute == .height {
                    constraint.constant = 0
                }
            }
            mailTF.constraints.forEach {(constraint) in
                if constraint.firstAttribute == .height {
                    constraint.constant = 0
                }
            }
            
            animateRegister(time: 1)
        } else {
            animateRegister(time: 0.5)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
