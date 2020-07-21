//
//  CreateGroupViewController.swift
//  House Hub
//
//  Created by Humza Raza on 6/30/20.
//  Copyright © 2020 dev. All rights reserved.
//
import FirebaseAuth
import FirebaseDatabase
import UIKit


class CreateGroupViewController: UIViewController {
    
    @IBOutlet weak var GroupName: UITextField!
    @IBOutlet weak var addCodeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        func randomString(length: Int) -> String {
          let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
          return String((0..<length).map{ _ in letters.randomElement()! })
        }
        let code = randomString(length: 5)
        addCodeLabel.text = "\(code)"
    }
    
    @IBAction func CreateBtn(_ sender: Any) {
        //if successful go to tab bar
        let ref = Database.database().reference()
        if(GroupName.text == ""){//field must have value
            return
        }
        
        ref.child("Groups/\(addCodeLabel.text!)/Users/\(userMngr.getUserId())").setValue(userMngr.getUserName())
        userMngr.setGroupId(groupId_in: addCodeLabel.text!)

        ref.child("Groups/\(addCodeLabel.text!)/GroupName").setValue(GroupName.text!)
        ref.child("users/\(Auth.auth().currentUser!.uid)/Group").setValue(addCodeLabel.text!)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(identifier: "TabBarController")
        
        /*************************************
        *ADD USERINFO TO  UserManager
        **************************************/
        userMngr.setGroupName(groupname_in: GroupName.text!)
        userMngr.setGroupId(groupId_in: addCodeLabel.text!)
        
        
        /*************************************
        *SEND CREATE MESSAGE
        **************************************/
        chatMngr.sendCreateGroupMessage(addCode: addCodeLabel.text!)
        
        // This is to get the SceneDelegate object from your view controller
        // then call the change root view controller function to change to main tab bar
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(tabBarController)
    }
}
