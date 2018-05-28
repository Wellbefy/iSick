//
//  KidSettingTVDataSource.swift
//  WellbefySjukskrivning
//
//  Created by Dennis Galvén on 2018-01-12.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation
import UIKit

class KidSettingTVDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    var viewController: UIViewController?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return User.sharedInstance.kids.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kidsetting", for: indexPath) as! KidSettingCell
        
        let kid = User.sharedInstance.kids[indexPath.row]
        cell.number = indexPath.row
        cell.nameNumberLabel.text = "\(kid.name!): \(kid.personNummer!)"
        cell.mailLabel.text = kid.email!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        (viewController as! SettingsVC).segueToAddKid(kid: indexPath.row)
    }
}
