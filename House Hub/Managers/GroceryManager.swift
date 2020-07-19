//
//  GroceryManager.swift
//  Task List
//
//  Created by Humza Raza on 6/24/20.
//  Copyright © 2020 dev. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
let ref = Database.database().reference()

var groceryMngr: GroceryManager = GroceryManager()

struct grocery{
    var name = "Un-Named"
    var desc = "Un-Described"
}

class GroceryManager: NSObject {
    var groceries: [grocery] = []
    func addGrocery(name: String, desc: String){
        ref.child("Groceries/\(userMngr.getGroupId())/\(name)").setValue(desc)
        groceries.append(grocery(name: name, desc: desc))
    }

}
