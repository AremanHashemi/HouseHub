//
//  ChangeUsername.swift
//  House Hub
//
//  Created by Patrick on 7/10/20.
//  Copyright © 2020 dev. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class ChangeUsernameViewController: UIViewController {

    
    @IBOutlet weak var newUserText: UITextField!
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
    @IBAction func editUserBtn(_ sender: Any) {
        if(newUserText.text == ""){
            return
        }
        ref.child("users").child(Auth.auth().currentUser!.uid).child("user").setValue(newUserText.text)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "ProfileVC")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
    }
    

}

