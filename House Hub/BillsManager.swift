//
//  BillsManager.swift
//  Task List
//
//  Created by Humza Raza on 6/26/20.
//  Copyright © 2020 dev. All rights reserved.
//

import UIKit

var billsMngr: BillsManager = BillsManager()

struct bill{
    var name = "Un-Named"
    var desc = "Un-Described"
    
}

class BillsManager: NSObject {
    var bills: [bill] = []
    
    func addBill(name: String, desc: String){
        bills.append(bill(name: name, desc: desc))
    }
}
