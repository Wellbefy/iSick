//
//  Colors.swift
//  WellbefySjukskrivning
//
//  Created by Dennis Galvén on 2018-01-09.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation
import UIKit

struct Colors {
    static let sharedInstance = Colors()
    
    let green = UIColor(displayP3Red: 0.61, green: 0.78, blue: 0.38, alpha: 1)
    let greenAlpha = UIColor(displayP3Red: 0.61, green: 0.78, blue: 0.38, alpha: 0.4)
    let lightGreen = UIColor(displayP3Red: 0.81, green: 0.98, blue: 0.65, alpha: 1)
    let orange = UIColor(displayP3Red: 1, green: 0.83, blue: 0.31, alpha: 1)
    let blueGray = UIColor(displayP3Red: 0.77, green: 0.84, blue: 0.84, alpha: 1)
    let darkGray = UIColor(displayP3Red: 0.33, green: 0.40, blue: 0.40, alpha: 1)
    let darkGrayAlpha = UIColor(displayP3Red: 0.33, green: 0.40, blue: 0.40, alpha: 0.4)
    let purple = UIColor(red:0.61, green:0.00, blue:0.38, alpha:1.0)
}
