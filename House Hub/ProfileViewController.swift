//
//  ProfileViewController.swift
//  Task List
//
//  Created by Humza Raza on 6/26/20.
//  Copyright © 2020 dev. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProfileViewController: UIViewController{
    
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var groupCode: UILabel!
    
    let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let profName = value?["user"] as? String ?? ""
            let gc = value?["Group"] as? String ?? ""
            self.profileName.text = profName + "'s " + self.profileName.text!
            self.groupCode.text = self.groupCode.text! + gc
            // ...
            }) { (error) in
                print(error.localizedDescription)
            }
        
    }
    @IBAction func changeUserBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "ChangeUserVC")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
    }
    
    @IBAction func changePassBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "ChangePassVC")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
    }
    
    @IBAction func leaveGroupBtn(_ sender: Any) {
        let userID = Auth.auth().currentUser?.uid
        
        /*************************************
        *SEND LEAVE MESSAGE
        **************************************/
        let gid = userMngr.getGroupId()
        chatMngr.sendLeaveGroupMessage(addCode: gid)
        
        
        ref.child("users/\(userID!)/Group").removeValue()
        userMngr.setGroupId(groupId_in: "")
        /*************************************
        *EMPTY LOCAL LISTS
        **************************************/
        groceryMngr.groceries.removeAll()
        
        /*************************************
        *GO TO JOIN CREATE GROUP PAGE
        **************************************/
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let join_create_grp = storyboard.instantiateViewController(identifier: "registerSuccess")
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(join_create_grp)
   
    }
        
    @IBAction func logoutBtn(_ sender: Any) {
        
          // ...
              // after user has successfully logged out
        do {
            try Auth.auth().signOut()
        }
        catch let signOutError as NSError {
            print("error signing out: %@", signOutError)
        }
        
        /*************************************
        *EMPTY LOCAL LISTS
        **************************************/
        groceryMngr.groceries.removeAll()
        
        /*************************************
        *GO TO LOG IN SCREEN
        **************************************/
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
        
    }
    @IBAction func joinGroupButton(_ sender: Any) {
        if(self.groupCode.text == "Group Code: "){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "JoinVC")
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
        }

    }
    
    /*@IBAction func leaveGroupButton(_ sender: Any) {
        self.groupCode.text = "Group Code: "
        ref.child("users").child(Auth.auth().currentUser!.uid).child("Group").setValue("")
    }*/
}
