//
//  KidSettingCell.swift
//  WellbefySjukskrivning
//
//  Created by Dennis Galvén on 2018-01-12.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class KidSettingCell: UITableViewCell {
    @IBOutlet weak var nameNumberLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    
    var number: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
