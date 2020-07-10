//
//  ChangePassword.swift
//  House Hub
//
//  Created by Patrick on 7/10/20.
//  Copyright © 2020 dev. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class ChangePasswordViewController: UIViewController {

    
    @IBOutlet weak var newPassText: UITextField!
    let ref = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "ProfileVC")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
    }
    
    @IBAction func editBtn(_ sender: Any) {
        if(newPassText.text == ""){
            return
        }
        /*let user = Auth.auth().currentUser
        var credential: AuthCredential

        // Prompt the user to re-provide their sign-in credentials

        user?.reauthenticate(with: credential) { error in
          if let error = error {
            // An error happened.
          } else {
            // User re-authenticated.
            Auth.auth().currentUser?.updatePassword(to: newPassText.text!) { (error) in
              // ...
            }
          }
        }*/
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "ProfileVC")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
    }
}
