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

        let ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        userMngr.setUserId(userId_in: userID!)
        let usersRef: Void = ref.child("Groups").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(self.joinCode.text!){
                ref.child("users/\(userID!)/Group").setValue(self.joinCode.text!)
                userMngr.setGroupId(groupId_in: self.joinCode.text!)
                userMngr.retGroupName(addCode: self.joinCode.text!)

                //Add current name to group
            }else{
                print("Please enter a valid code")
                return
            }
        })
        
        _ = ref.child("users").child(userID!).child("Group").observeSingleEvent(of: .value, with: { (snapshot) in
            if let group = snapshot.value  as? String{
                print(group)
                ref.child("Groceries/\(group)").observeSingleEvent(of: .value, with: { (snapshot) in
                    let groceryList = snapshot.value as? [String:String] ?? [:]
                    print(groceryList)
                    for (name, desc) in groceryList{
                        groceryMngr.addGrocery(name: name, desc: desc)
                    }
                })
            }
        })
                
        // This is to get the SceneDelegate object from your view controller
        // then call the change root view controller function to change to main tab bar
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(identifier: "TabBarController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(tabBarController)
    
        //======Chat Init=======
//        let name = userMngr.getUserName()
//        let userid = userMngr.getUserId()
//        let ac = userMngr.getGroupId()
//        let content = "AUTO: \(name) has joined \(userMngr.getGroupName())"
//        let sender = Sender(senderId: userid,
//                            displayName: name)
//
//        let message = Message(kind: .text(content),
//                              sender: sender,
//                              messageId: chatMngr.createMessageId(),
//                              sentDate: Date())
//
//        chatMngr.sendMessage(addCode: ac, newMessage: message, completion: { success in
//            if success {
//                print("Join message sent")
//            } else {
//                print("Failed to notify joining member")
//            }
//        })
        let ac = userMngr.getGroupId()
        chatMngr.sendJoinGroupMessage(addCode: ac)
    }

}
