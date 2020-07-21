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

    
    @IBOutlet weak var currEmail: UITextField!
    @IBOutlet weak var currPass: UITextField!
    @IBOutlet weak var newPassText: UITextField!
    @IBOutlet weak var errorMsg: UILabel!
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
        if(newPassText.text == "" || currEmail.text == "" || currPass.text == ""){
            return
        }
        let user = Auth.auth().currentUser
        var credential: AuthCredential = EmailAuthProvider.credential(withEmail: currEmail.text!, password: currPass.text!)

        // Prompt the user to re-provide their sign-in credentials

        user?.reauthenticate(with: credential, completion: { (result, error) in
           if let err = error {
              //..read error message
            self.errorMsg.text = "Invalid info!"
            return
           } else {
              //.. go on
            Auth.auth().currentUser?.updatePassword(to: self.newPassText.text!) { (error) in
              // ...
                print("success")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "ProfileVC")
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
            }
           }
        })
    }
}
