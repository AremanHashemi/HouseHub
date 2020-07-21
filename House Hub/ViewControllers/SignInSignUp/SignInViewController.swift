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
        
//        LoginImage.layer.masksToBounds = true
            //  LoginImage.layer.cornerRadius = LoginImage.bounds.width / 2

        // Do any additional setup after loading the view.
    }
    
    //IOS touch fcns
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        textField.resignFirstResponder()
        
        return true
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
        login()
    }
    
    func login(){
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { [weak self] authResult, err in
            guard let strongSelf = self else {return}
            if let err = err {
                print(err.localizedDescription)
            }
            strongSelf.checkUser()
        }
    }
    
    func checkUser(){
        if Auth.auth().currentUser != nil {
            
            /***********************************
            * GROCERY DATA
            ************************************/
            let ref = Database.database().reference()
            
            
            //USER ID
            userMngr.setUserId(userId_in: (Auth.auth().currentUser!.uid))//sets user id for global user
            print("USER ID: \(userMngr.getUserName())")
            
            //Photo ID
            _ = ref.child("users").child(userMngr.getUserId()).child("photoID").observeSingleEvent(of: .value, with: { (snapshot) in
                if let photoID = snapshot.value  as? String{
                    userMngr.setPhotoId(photoId_in: photoID)//sets username for global user
                }
                //print("photoID: \(userMngr.getPhotoId())")
            })
            
            //Photo URL
            _ = ref.child("users").child(userMngr.getUserId()).child("photoURL").observeSingleEvent(of: .value, with: { (snapshot) in
                if let photoURL = snapshot.value  as? String{
                    userMngr.setPhotoUrl(photoUrl_in: photoURL)//sets username for global user
                }
                print("photoURL: \(userMngr.getPhotoUrl())")
            })
            
                //USER NAME
                _ = ref.child("users").child(userMngr.getUserId()).child("user").observeSingleEvent(of: .value, with: { (snapshot) in
                    if let username = snapshot.value  as? String{
                        userMngr.setUserName(username_in: username)//sets username for global user
                    }
            //        print("NAME: \(userMngr.getUserName())")
                })
            
            //GROUP ID
            _ = ref.child("users").child(userMngr.getUserId()).child("Group").observeSingleEvent(of: .value, with: { (snapshot) in
                if let group = snapshot.value  as? String{
                    userMngr.setGroupId(groupId_in: group)//sets group id for global user

                    let gid = userMngr.getGroupId()
                    print("gid: \(gid)")
                    userMngr.retGroupName(addCode: gid)
                    print("gname: \(userMngr.getGroupName())")
                    userMngr.setPhotoId(photoId_in: "https://firebasestorage.googleapis.com/v0/b/househub-a961b.appspot.com/o/Users%2F5Q7O5AjA8GgEyHmJsQO0qJbmzf13%2FEE02E776-05A7-4594-8612-416D5B27F19B?alt=media&token=6ee7c42b-94f1-4ebd-8938-99833b57318b")
                    
                
                

                    /***********************************
                    * GO TO APP
                    ************************************/
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let tabBarController = storyboard.instantiateViewController(identifier: "TabBarController")
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(tabBarController)
                }
                else{
                    /*************************************
                    *GO TO JOIN CREATE GROUP PAGE
                    **************************************/
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let join_create_grp = storyboard.instantiateViewController(identifier: "registerSuccess")
                                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(join_create_grp)
                }
            })

        }else{
            //invalidUser.text = "Invalid user"
        }
    }
}
