//
//  JoinGroupViewController.swift
//  House Hub
//
//  Created by Humza Raza on 6/30/20.
//  Copyright © 2020 dev. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class JoinGroupViewController: UIViewController {

    
    @IBOutlet weak var joinCode: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func joinBtn(_ sender: Any) {
        //if successful
        //go to tab bar
        //let ref = Database.database().reference()
        //ref.child("Groups")
        if self.joinCode.text == ""{
            return
        }
        let addCode = self.joinCode.text!
        let ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        userMngr.setUserId(userId_in: userID!)
        let usersRef: Void = ref.child("Groups").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(addCode){
                ref.child("users/\(userID!)/Group").setValue(self.joinCode.text!)
               
                ref.child("Groups/\(addCode)/Users/\(userMngr.getUserId())").setValue(userMngr.getUserName())
                userMngr.setGroupId(groupId_in: addCode)
                userMngr.retGroupName(addCode: addCode)

                //take to join group success if code is valid
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let jgs = storyboard.instantiateViewController(identifier: "JoinGroupSuccess")
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(jgs)
                //Add current name to group
            }else{//code is invalid
                print("Please enter a valid code")
                return
            }
        })
         
        /*************************************
        *SEND JOIN MESSAGE
        **************************************/
        let ac = addCode
        chatMngr.sendJoinGroupMessage(addCode: ac)
    }

}
