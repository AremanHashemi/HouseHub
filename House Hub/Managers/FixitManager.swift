//
//  FixitManager.swift
//  Task List
//
//  Created by Humza Raza on 6/26/20.
//  Copyright © 2020 dev. All rights reserved.
//

import UIKit
import FirebaseStorage

var fixesMngr: FixesManager = FixesManager()

struct fix{
    var id = "NONE"
    var date = "NONE"
    var url = "NONE"
    var desc = "Un-Described"
}

class FixesManager: NSObject {
    var fixes: [fix] = []
    
    func addFix(id: String, date: String, url: String, desc: String){
        fixes.insert(fix(id: id, date: date, url: url, desc: desc), at: 0)
    }
}
