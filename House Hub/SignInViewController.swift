//
//  SignInViewController.swift
//  House Hub
//
//  Created by Humza Raza on 6/30/20.
//  Copyright © 2020 dev. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SignInViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signInButton(_ sender: Any) {//switches from login screen to actual app if user is authenticated and loads all data
        //sign in
        //if authenticated
    /***********************************
    * LOAD DATA FROM DATABASE
    ************************************/
        /***********************************
        * GROCERY DATA
        ************************************/
        let ref = Database.database().reference()
        ref.child("Groceries/test-group").observeSingleEvent(of: .value, with: { (snapshot) in
            let groceryList = snapshot.value as? [String:String] ?? [:]
            print(groceryList)
            for (name, desc) in groceryList{
                groceryMngr.addGrocery(name: name, desc: desc)
            }
        })
        /***********************************
        * GO TO APP
        ************************************/
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(identifier: "TabBarController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(tabBarController)
    }
}
