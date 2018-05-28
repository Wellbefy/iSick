//
//  LaunchScreen.swift
//  WellbefySjukskrivning
//
//  Created by Dennis Galvén on 2018-02-09.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation
import UIKit

class LaunchScreen: UIViewController {
    
    var originalHeigth: NSLayoutConstraint?
    var smallerHeight: NSLayoutConstraint?
    var logoView: UIImageView?
    var nameLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let greenTopView = UIView()
        greenTopView.backgroundColor = Colors.sharedInstance.green
        
        view.addSubview(greenTopView)
        
        greenTopView.translatesAutoresizingMaskIntoConstraints = false
        [
            greenTopView.topAnchor.constraint(equalTo: view.topAnchor),
            greenTopView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            greenTopView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            greenTopView.heightAnchor.constraint(equalToConstant: 20)
            ].forEach {$0.isActive = true}
        
        let greenBottomView = UIView()
        greenBottomView.backgroundColor = Colors.sharedInstance.green
        
        view.addSubview(greenBottomView)
        
        greenBottomView.translatesAutoresizingMaskIntoConstraints = false
        [
            greenBottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            greenBottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            greenBottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            greenBottomView.heightAnchor.constraint(equalToConstant: 20)
            ].forEach {$0.isActive = true}
        
        logoView = UIImageView()
        if let logoView = logoView {
            logoView.image = #imageLiteral(resourceName: "Logga")
            logoView.backgroundColor = .clear
            logoView.contentMode = .scaleAspectFit
            
            view.addSubview(logoView)
            
            logoView.translatesAutoresizingMaskIntoConstraints = false
            [
                logoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                logoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                logoView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
                ].forEach {$0.isActive = true}
            originalHeigth = logoView.heightAnchor.constraint(equalToConstant: 100)
            originalHeigth?.isActive = true
            smallerHeight = logoView.heightAnchor.constraint(equalToConstant: 50)
            smallerHeight?.isActive = false
        }
        
        nameLabel = UILabel()
        if let nameLabel = nameLabel {
            nameLabel.text = "iSick"
            nameLabel.font = UIFont(name: "Raleway", size: 24)
            nameLabel.textColor = Colors.sharedInstance.green
            nameLabel.textAlignment = .center
            
            view.addSubview(nameLabel)
            
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            [
                nameLabel.topAnchor.constraint(equalTo: logoView!.bottomAnchor, constant: 10),
                nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                nameLabel.heightAnchor.constraint(equalToConstant: 30)
                ].forEach {$0.isActive = true}
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animateDown()
    }
    
    func animateDown() {
        self.originalHeigth?.isActive = false
        self.smallerHeight?.isActive = true
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseIn, animations: {
            if let logoView = self.logoView {
                logoView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            }
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.animateUp()
        })
    }
    
    func animateUp() {
        self.originalHeigth?.isActive = true
        self.smallerHeight?.isActive = false
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: {
            if let logoView = self.logoView {
                logoView.transform = CGAffineTransform(rotationAngle: 0)
            }
            self.view.layoutIfNeeded()
        }, completion: {_ in
            self.dismiss()
        })
    }
    
    private func dismiss() {
//        let transition: CATransition = CATransition()
//        transition.duration = 0.5
//        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//        transition.type = kCATransitionFade
//        transition.subtype = kCATransitionReveal
//        self.view.window?.layer.add(transition, forKey: nil)
        
        performSegue(withIdentifier: "toapp", sender: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        animateDown()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        debugPrint("körs")
    }
}
