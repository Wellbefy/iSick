//
//  MailCell.swift
//  WellbefySjukskrivning
//
//  Created by Dennis Galvén on 2018-01-18.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

protocol MailCellDelegate: class {
    func didChangeText(_ sender: MailCell)
}

class MailCell: UICollectionViewCell {
    @IBOutlet weak var mailLabel: UILabel!
    
    weak var delegate: MailCellDelegate?
    
    var cellNumber: Int?
    
    var text: String? {
        didSet {
            mailLabel.text = text
        }
    }
    
    var textView = UITextView()
    
    override func awakeFromNib() {
//        self.backgroundColor = Colors().darkGray
//        self.mailLabel.textColor = Colors().blueGray
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = Colors().darkGray.cgColor
        self.mailLabel.textColor = Colors().darkGray
        self.mailLabel.textAlignment = .left
        
        textView.font = mailLabel.font
        textView.isHidden = true
        
        addSubview(textView)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        [
            textView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 10),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 10)
            ].forEach { $0.isActive = true}
        
        setDoneOnKeyboard()
    }
    
    func setLabelText(text: String) {
        self.mailLabel.text = text
    }
    
    func editText() {
        mailLabel.isHidden = true
        
        textView.text = text ?? ""
        textView.isHidden = false
        
        textView.becomeFirstResponder()
    }
    
    func setDoneOnKeyboard() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneEdit))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        textView.inputAccessoryView = keyboardToolbar
    }
    
    @objc func doneEdit() {
        text = textView.text
        
        textView.resignFirstResponder()
        
        textView.isHidden = true
        mailLabel.isHidden = false
        
        delegate?.didChangeText(self)
    }
}
