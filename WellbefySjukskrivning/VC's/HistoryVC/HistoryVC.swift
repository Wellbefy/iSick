//
//  HistoryVC.swift
//  WellbefySjukskrivning
//
//  Created by Dennis Galvén on 2018-01-10.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit

class HistoryVC: UIViewController {
    @IBOutlet weak var historyTV: UITableView!
    
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var rightView: UIView!
    
    var sickPercentCircle = ShapeLayers()
    var totalPercentCircle = ShapeLayers()
    var vabPercentCircle = ShapeLayers()
    
    @IBOutlet weak var sickPercentLabel: PercentAnimationLabel!
    @IBOutlet weak var vabPercentLabel: PercentAnimationLabel!
    @IBOutlet weak var totalPercentLabel: PercentAnimationLabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyTV.dataSource = self
        historyTV.delegate = self
        historyTV.allowsSelection = false
        
        dateLabel.isUserInteractionEnabled = true
        dateLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedDateLabel(_:))))
        setDateLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        sickPercentLabel.currentPercent = 0
        vabPercentLabel.currentPercent = 0
        totalPercentLabel.currentPercent = 0
        
        sickPercentLabel.text = "Jobb:\n0%"
        vabPercentLabel.text = "Sjuk:\n0%"
        totalPercentLabel.text = "VAB:\n0%"
        
        addCircles()
        addAnimationCircles()
        loadTV()
    }
    
    func setDateLabel(event: Event = Event(), force: Bool = false) {
        var date = Date()
        
        if force {
            date = event.date!
        }
        
        let month = Calendar.current.component(.month, from: date)
        let year = Calendar.current.component(.year, from: date)
        debugPrint(month)
        dateLabel.text = "\(Months.months[month-1]) \(year)"
        
    }
    
    @objc func tappedDateLabel(_ sender: Any) {
        setDateLabel()
        animateCircles()
    }
    
    private func loadTV() {
        historyTV.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
