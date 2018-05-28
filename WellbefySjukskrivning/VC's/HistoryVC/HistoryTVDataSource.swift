//
//  HistoryTVDataSource.swift
//  WellbefySjukskrivning
//
//  Created by Dennis Galvén on 2018-01-15.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation
import UIKit

extension HistoryVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return User.sharedInstance.sortedEvents[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = User.sharedInstance.sortedEvents[indexPath.section][indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "historycell", for: indexPath) as! HistoryTVCell
        
        cell.nameLabel.text = event.name!
        
        if event.isVab() {
            cell.dateLabel.text = "\(event.stringFromDate()) - vab"
        } else {
            cell.dateLabel.text = "\(event.stringFromDate()) - sjuk"
        }
        
        cell.reportedLabel.isHidden = true
        
        if let reported = event.reportedToFk {
            if reported {
                cell.reportedLabel.isHidden = false
            }
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return User.sharedInstance.sortedEvents.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        
        if let date = User.sharedInstance.sortedEvents[section].first?.date  {
            let year = Calendar.current.component(.year, from: date)
            let month = Calendar.current.component(.month, from: date)
            
            label.font = UIFont(name: "Raleway", size: 20)
            label.textColor = Colors.sharedInstance.darkGray
            label.backgroundColor = UIColor.white
            label.isUserInteractionEnabled = true
            label.tag = section
            label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedHeader(_:))))
            label.text = "\(Months.months[month - 1]) \(year)"
        }

        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 22
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Radera", handler: {action, indexPath in
            debugPrint("section: \(indexPath.section)")
            debugPrint("row: \(indexPath.row)")
            
            let events = User.sharedInstance.sortedEvents[indexPath.section]
            debugPrint("events count: \(events.count)")
            let event = events[indexPath.row]
            debugPrint(event.name as Any)
            debugPrint(event.id as Any)
            
            if let id = event.id {
                debugPrint(id)
                User.sharedInstance.event.removeEvent(id: id)
                User.sharedInstance.sortedEvents[indexPath.section].remove(at: indexPath.row)
                debugPrint("removed count: \(User.sharedInstance.sortedEvents[indexPath.section].count)")
                tableView.deleteRows(at: [indexPath], with: .bottom)
                self.historyTV.reloadData()
                self.animateCircles()
            }
        })
        delete.backgroundColor = Colors.sharedInstance.purple
        
        return [delete]
    }
    
    @objc func tappedHeader(_ sender: UITapGestureRecognizer) {
        var indexPath = IndexPath(row: 0, section: 0)
        let location = sender.location(in: historyTV)
        let section = historyTV.indexPathForRow(at: location)
        
        if let section = section {
            indexPath = section
        }
        
        animateCircles(month: indexPath.section, force: true)
        if let event = User.sharedInstance.sortedEvents[indexPath.section].first {
            setDateLabel(event: event, force: true)
        }
        
        historyTV.scrollToRow(at: indexPath, at: .none, animated: true)
    }
}
