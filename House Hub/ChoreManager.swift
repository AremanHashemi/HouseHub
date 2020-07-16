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
    var choreName = ""
    var chorePerson = ""
    var deadline = "NONE"
    var username = "Un_Named"
}

class ChoreManager: NSObject {
    var chores: [chore] = []
    
    func addChore(choreName: String, chorePerson: String, deadline: String, username: String){
        chores.append(chore(choreName: choreName, chorePerson: chorePerson, deadline: deadline, username: username))
        let list = [chorePerson, deadline, username]
        ref.child("Chores/\(userMngr.getGroupId())/\(choreName)").setValue(list)
    }
}
