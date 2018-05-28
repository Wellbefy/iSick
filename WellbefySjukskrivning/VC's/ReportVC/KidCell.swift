//
//  KidCell.swift
//  WellbefySjukskrivning
//
//  Created by Dennis Galvén on 2018-01-10.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class KidCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var prnNrLabel: UILabel!
    @IBOutlet weak var cellSwitch: UISwitch!
    
    var number: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func sickSwitch(_ sender: Any) {
        User.sharedInstance.kids[number!].isSick = cellSwitch.isOn
    }
    
    func getHeight() -> CGFloat {
        return self.frame.size.height
    }
}
