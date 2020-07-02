//
//  SignInViewController.swift
//  House Hub
//
//  Created by Humza Raza on 6/30/20.
//  Copyright © 2020 dev. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignInViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var enterEmail: UILabel!
    @IBOutlet weak var enterPassword: UILabel!
    @IBOutlet weak var invalidUser: UILabel!
    
    @IBOutlet weak var LoginImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LoginImage.layer.masksToBounds = true
              LoginImage.layer.cornerRadius = LoginImage.bounds.width / 2

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        checkUser()
    }
    
    @IBAction func signInButton(_ sender: Any) {
        validateFields()
    }
    
    func validateFields(){
        if(email.text?.isEmpty == true){
            enterEmail.text = "Please enter email."
            print("Please enter email.")
            return
        }
        else if(password.text?.isEmpty == true){
            enterPassword.text = "Please enter password."
            print("Please enter password.")
            return
        }
        else if(Auth.auth().currentUser == nil){
            invalidUser.text = "Invalid user"
        }
        login()
    }
    
    func login(){
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { [weak self] authResult, err in
            guard let strongSelf = self else {return}
            if let err = err {
                print(err.localizedDescription)
            }
        }
        self.checkUser()
    }
    
    func checkUser(){
        if Auth.auth().currentUser != nil {
            print(Auth.auth().currentUser?.uid)
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
}
