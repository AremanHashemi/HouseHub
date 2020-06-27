//
//  ChoreManager.swift
//  Task List
//
//  Created by Humza Raza on 6/24/20.
//  Copyright © 2020 dev. All rights reserved.
//

import UIKit

var choreMngr: ChoreManager = ChoreManager()

struct chore{
    var name = "Un-Named"
    var desc = "Un-Described"
    
}

class ChoreManager: NSObject {
    var chores: [chore] = []
    
    func addChore(name: String, desc: String){
        chores.append(chore(name: name, desc: desc))
    }
}
