//
//  DeleteAccountViewController.swift
//  House Hub
//
//  Created by Humza Raza on 7/19/20.
//  Copyright © 2020 dev. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Kingfisher

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
                     let storageRef = Storage.storage().reference().child("Users/\(userMngr.getUserId())/\(userMngr.getPhotoId())")
                    // Delete the file from storage
                    storageRef.delete { error in
                     if error != nil {
                        print("nothing deleted")
                      } else {
                        print("image deleted")
                      }
                    }
                    
                    let numHousemates = housematesMngr.housemates.count
                           if(numHousemates == 1){
                            self.ref.child("Groups/\(gid)").removeValue()
                            self.ref.child("Bills/\(gid)").removeValue()
                            self.ref.child("Chores/\(gid)").removeValue()
                            self.ref.child("Fixit/\(gid)").removeValue()
                            self.ref.child("Groceries/\(gid)").removeValue()
                            self.ref.child("Groupchats/groupchat_\(gid)").removeValue()
                           }
                           else{
                            self.ref.child("Groups/\(gid)/Users/\(userMngr.getUserId())").removeValue()
                               chatMngr.sendLeaveGroupMessage(addCode: gid)//send leave message
                           }
                    //remove user id from db
                    self.ref.child("users/\(userMngr.getUserId())").removeValue()
                    /********************************************
                    *EMPTY LOCAL LISTS AND RESET INFO TO DEFAULT
                    *********************************************/
                    groceryMngr.groceries.removeAll()
                    choreMngr.chores.removeAll()
                    billsMngr.bills.removeAll()
                    fixesMngr.fixes.removeAll()
                    userMngr.setUserId(userId_in: "")
                    userMngr.setGroupId(groupId_in: "")
                    userMngr.setUserName(username_in: "")
                    userMngr.setGroupName(groupname_in: "")
                    userMngr.setPhotoId(photoId_in: "default")
                    userMngr.setPhotoUrl(photoUrl_in: "https://firebasestorage.googleapis.com/v0/b/househub-a961b.appspot.com/o/Users%2Fdefault%2Fdefault?alt=media&token=5b7b4873-3671-40fa-8428-4c02549e53c0")
                    userMngr.housemates.removeAll()
                    
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
