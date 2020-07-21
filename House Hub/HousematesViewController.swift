//
//  FixitViewController.swift
//  Task List
//
//  Created by Humza Raza on 6/26/20.
//  Copyright © 2020 dev. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import Kingfisher

class HouseMatesTableViewCell: UITableViewCell{
    override func awakeFromNib() {
          super.awakeFromNib()
      }
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var userNamelbl: UILabel!
}

class HousematesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    @IBOutlet weak var tblHousemates: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblHousemates.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool){
         tblHousemates.reloadData()
    }
    
    //UItableview data source
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return housematesMngr.housemates.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
            let h_cell = tableView.dequeueReusableCell(withIdentifier: "HouesemateCell", for: indexPath) as! HouseMatesTableViewCell
            let housemate = housematesMngr.housemates[indexPath.row]
            let imageURL = URL(string: housemate.url)
            h_cell.profilePic.kf.setImage(with: imageURL)
            h_cell.profilePic.layer.cornerRadius = h_cell.profilePic.frame.height/2
            h_cell.userNamelbl.text = housematesMngr.housemates[indexPath.row].name
            return h_cell
       }
}
