//
//  FixitManager.swift
//  Task List
//
//  Created by Humza Raza on 6/26/20.
//  Copyright © 2020 dev. All rights reserved.
//

import UIKit
import FirebaseStorage

var housematesMngr: HousemateManager = HousemateManager()

struct housemate{
    var id = "NONE"
    var url = "NONE"
    var name = "None"
}

class HousemateManager: NSObject {
    var housemates: [housemate] = []
    
    func addHousemate(id: String, name: String, url: String){
        housemates.append(housemate(id: id, url: url, name: name))
    }
}
