//
//  DeleteAccountViewController.swift
//  House Hub
//
//  Created by Humza Raza on 7/19/20.
//  Copyright © 2020 dev. All rights reserved.
//

import UIKit
import UIKit
import FirebaseAuth
import FirebaseDatabase

class DeleteAccountViewController: UIViewController {
    
    
    @IBOutlet weak var currPass: UITextField!
    @IBOutlet weak var currEmail: UITextField!
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
        
        @IBAction func deletetBtn(_ sender: Any) {
            if(currEmail.text == "" || currPass.text == ""){
                return
            }
            let user = Auth.auth().currentUser
            var credential: AuthCredential = EmailAuthProvider.credential(withEmail: currEmail.text!, password: currPass.text!)

            // Prompt the user to re-provide their sign-in credentials

            user?.reauthenticate(with: credential, completion: { (result, error) in
               if let err = error {
                  //..read error message
                print(err)
                self.errorMsg.text = "Invalid info!"
                return
               } else {
                  //.. go on
                let user = Auth.auth().currentUser

                user?.delete { error in
                  if let error = error {
                    // An error happened.
                    print(error)
                  } else {
                    let gid = userMngr.getGroupId()
                    chatMngr.sendLeaveGroupMessage(addCode: gid)//leave group messages
                    // Account deleted.
                    self.ref.child("users/\(userMngr.getUserId())").removeValue()
                    //delete from housemates list here
                    print("success")
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(identifier: "LoginNavController")
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
                  }
                }
               }
            })
        }
    }
