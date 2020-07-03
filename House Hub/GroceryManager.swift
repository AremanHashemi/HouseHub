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
 //   let group = ref.child("users/\(Auth.auth().currentUser!.uid)/").value(forKey: "Group")

    func addGrocery(name: String, desc: String){
        let userID = Auth.auth().currentUser?.uid
        let usersRef = ref.child("users").child(userID!).child("Group").observeSingleEvent(of: .value, with: { (snapshot) in
            if let group = snapshot.value  as? String{
                 ref.child("Groceries/\(group)/\(name)").setValue(desc)
            }
        })
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

