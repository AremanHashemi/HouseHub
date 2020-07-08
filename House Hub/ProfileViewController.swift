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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func leaveGrpBtn(_ sender: Any) {
        let ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        ref.child("users/\(userID!)/Group").removeValue()
        
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
    
}
