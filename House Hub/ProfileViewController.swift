//
//  ProfileViewController.swift
//  Task List
//
//  Created by Humza Raza on 6/26/20.
//  Copyright © 2020 dev. All rights reserved.
//

import UIKit
import FirebaseAuth


class ProfileViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        groceryMngr.groceries.removeAll()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavController")

        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
        
    }
    
}
