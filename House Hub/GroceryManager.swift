//
//  GroceryManager.swift
//  Task List
//
//  Created by Humza Raza on 6/24/20.
//  Copyright © 2020 dev. All rights reserved.
//

import UIKit
import FirebaseDatabase
let ref = Database.database().reference()

var groceryMngr: GroceryManager = GroceryManager()

struct grocery{
    var name = "Un-Named"
    var desc = "Un-Described"
}

class GroceryManager: NSObject {
    var groceries: [grocery] = []
    func addGrocery(name: String, desc: String){
        ref.child("Groceries/test-group/\(name)").setValue(desc)
        groceries.append(grocery(name: name, desc: desc))
        //dbUpdate()
    }
}

//func dbUpdate() {
//    _ = ref.observe(DataEventType.value, with: { (snapshot) in
//      let postDict = snapshot.value as? [String : AnyObject] ?? [:]
//        print(postDict)
//    })
//}

