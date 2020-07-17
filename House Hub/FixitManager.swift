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
    var image: UIImage? = nil
    var desc = "Un-Described"
    var imageID = "NONE"
    var dateAdded = ""
}

class FixesManager: NSObject {
    var fixes: [fix] = []
    
    func addFix(image: UIImage, desc: String, imageID: String, dateAdded: String){
        fixes.insert(fix(image: image, desc: desc, imageID: imageID, dateAdded: dateAdded), at: 0)
        let list = ["desc" : desc, "dateAdded" : dateAdded]
        ref.child("Fixit/\(userMngr.getGroupId())/\(imageID)").setValue(list)
    }
}
