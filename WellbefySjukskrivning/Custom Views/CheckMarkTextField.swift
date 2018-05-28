//
//  CheckMarkTextField.swift
//  WellbefySjukskrivning
//
//  Created by Dennis Galvén on 2018-01-15.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class CheckMarkTextField: UITextField {
    let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    func isCorrect(correct: Bool) {
        image.image = UIImage(named: "CheckMark")
        image.tintColor = Colors().green
        self.rightView = image
        if correct {
            self.rightViewMode = .always
        } else {
            self.rightViewMode = .never
        }
    }
    
    func correct() -> Bool {
        return self.rightViewMode == .always
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let rightBound = CGRect(x: bounds.size.width-22, y: 6, width: 18, height: 18)
        return rightBound
    }
}
