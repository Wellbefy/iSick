//
//  KidTVDataSource.swift
//  WellbefySjukskrivning
//
//  Created by Dennis Galvén on 2018-01-10.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation
import UIKit

class KTVDataSource: NSObject, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return User.sharedInstance.kids.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let kids = User.sharedInstance.kids
        let cell = tableView.dequeueReusableCell(withIdentifier: "kidcell", for: indexPath) as! KidCell
        
        cell.number = indexPath.row
        
        cell.nameLabel.text = kids[indexPath.row].name
        cell.prnNrLabel.text = kids[indexPath.row].personNummer
        cell.cellSwitch.isOn = kids[indexPath.row].isSick
        
        return cell
    }
    
}
