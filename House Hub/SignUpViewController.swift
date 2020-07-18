//
//  SignUpViewController.swift
//  House Hub
//
//  Created by Humza Raza on 6/30/20.
//  Copyright © 2020 dev. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SignUpViewController: UIViewController {

    @IBOutlet weak var user: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var enterUser: UILabel!
    @IBOutlet weak var enterEmail: UILabel!
    @IBOutlet weak var enterPassword: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerButton(_ sender: Any) {
        if(user.text?.isEmpty == true){
            enterUser.text = "Please enter user."
            print("Please enter user.")
            return
        }
        else if(email.text?.isEmpty == true){
            enterEmail.text = "Please enter email."
            print("Please enter email.")
            return
        }
        else if(password.text?.isEmpty == true){
            enterPassword.text = "Please enter password."
            print("Please enter password.")
            return
        }
        else if(password.text!.count < 6){
            enterPassword.text = "Password must be at least 6 characters."
            return
        }
        
        
        createUser()
    }
    
    
    func createUser() {
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (authResult, error) in
            guard let u = authResult?.user, error == nil else {
                print("failed to sign user up with error: \(error?.localizedDescription)")
                return
            }
            print("Success")
            
            /*guard let uid = result?.user.uid else {return}
            
            let values = ["email":email, "user":user]
            
            Database.database().reference().child("users").child(uid).updateChildValues(values, withCompletionBlock: {(error, ref) in
                if let error = error {
                    print("failed to update database values with error: ", error.localizedDescription)
                    return
                }
            })*/
            let ref = Database.database().reference()
            let values = [ "user" : self.user.text,
                           "email" : self.email.text]
            
            ref.child("users").child(Auth.auth().currentUser!.uid).setValue(values)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "registerSuccess")
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
        
            // Set UserManager username
            userMngr.setUserName(username_in: self.user.text!)
            // Send Join message
            userMngr.setUserId(userId_in: Auth.auth().currentUser!.uid)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
