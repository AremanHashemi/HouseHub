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
    var image: UIImage? = nil
    var desc = "Un-Described"
}

class FixesManager: NSObject {
    var fixes: [fix] = []
    
    func addFix(image: UIImage, desc: String){
        fixes.insert(fix(image: image, desc: desc), at: 0)
    }
}
