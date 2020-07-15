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
    var price = "0.00"
    var split = "0"
    var deadline = "NONE"
    var username = "Un_Named"
}

class BillsManager: NSObject {
    var bills: [bill] = []
    
    func addBill(name: String, price: String, split: String, deadline: String, username: String){
        bills.append(bill(name: name, price: price, split: split, deadline: deadline, username: username))
        let list = [price, split, deadline, username]
        ref.child("Bills/\(userMngr.getGroupId())/\(name)").setValue(list)
    }
}
