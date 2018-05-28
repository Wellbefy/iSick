//
//  CheckPersonNummer.swift
//  WellbefySjukskrivning
//
//  Created by Dennis Galvén on 2018-01-11.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation

class CheckPersonNummer {
    
    func checkPersonNr(nr: String) -> Bool {
        if nr.count != 11 {
            return false
        }
        
        let newNr = nr.replacingOccurrences(of: "-", with: "")
        
        return lastDigit(personNrToCheck: newNr)
    }
    
    //Checks if personnummers last digit is correct
    private func lastDigit(personNrToCheck: String) -> Bool {
        if personNrToCheck.isEmpty {
            return false
        }
        
        var numbers = [Int]()
        var even = false
        
        let last = Int(String(personNrToCheck.last!))
        let withoutLast = personNrToCheck.dropLast()
        
        for i in withoutLast {
            let currentNumber = String(i)
            
            if !even {
                let twice = Int(currentNumber)! * 2
                
                if twice > 9 {
                    numbers.append(1)
                }
                
                numbers.append(twice % 10)
                
                even = true
            } else {
                numbers.append(Int(currentNumber)!)
                
                even = false
            }
        }
        
        var calculation = 0
        for i in numbers {
            calculation = calculation + i
        }
        let lastDigit = (10 - (calculation % 10)) % 10
        
        return lastDigit == last!
    }
}
