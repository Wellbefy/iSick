//
//  HistoryTVCell.swift
//  WellbefySjukskrivning
//
//  Created by Dennis Galvén on 2018-01-10.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class HistoryTVCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var reportedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        reportedLabel.textColor = Colors.sharedInstance.purple
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
