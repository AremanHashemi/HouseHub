//
//  FixitManager.swift
//  Task List
//
//  Created by Humza Raza on 6/26/20.
//  Copyright © 2020 dev. All rights reserved.
//

import UIKit

var fixesMngr: FixesManager = FixesManager()

struct fix{
    var name = "Un-Named"
    var desc = "Un-Described"
    
}

class FixesManager: NSObject {
    var fixes: [fix] = []
    
    func addFix(name: String, desc: String){
        fixes.append(fix(name: name, desc: desc))
    }
}
