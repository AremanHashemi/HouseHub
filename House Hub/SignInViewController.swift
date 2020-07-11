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
    
    //IOS touch fcns
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        textField.resignFirstResponder()
        
        return true
    }

    override func viewDidAppear(_ animated: Bool) {
        checkUser(completion: { success in
            if success {
                print("User logged in successfully")
  //              let uid = userMngr.getUserId()
 //               userMngr.setUserData(userid: uid)

                
            } else {
                print("User not logged in")
            }
        })
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
        
    }
    
    func login(){
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { [weak self] authResult, err in
            guard let strongSelf = self else {
                return
            }
            if let err = err {
                print(err.localizedDescription)
            }
            strongSelf.checkUser(completion: { success in })
        }
    }
    
    func checkUser(completion: @escaping (Bool) -> Void){

        if Auth.auth().currentUser != nil {
            
            /***********************************
            * GROCERY DATA
            ************************************/
            let ref = Database.database().reference()
            
            //USER ID
            userMngr.setUserId(userId_in: (Auth.auth().currentUser!.uid))//sets user id for global user
            print("USER ID: \(userMngr.getUserName())")
            
            //USER NAME
            _ = ref.child("users").child(userMngr.getUserId()).child("user").observeSingleEvent(of: .value, with: { (snapshot) in
                if let username = snapshot.value  as? String{
                    userMngr.setUserName(username_in: username)//sets username for global user
                }
                print("NAME: \(userMngr.getUserName())")
            })
            
            //GROUP ID
            _ = ref.child("users").child(userMngr.getUserId()).child("Group").observeSingleEvent(of: .value, with: { (snapshot) in
                if let group = snapshot.value  as? String{
                    
                    userMngr.setGroupId(groupId_in: group)//sets group id for global user
                    
                    print("Group ID: \(userMngr.getGroupId())")
                    
                    ref.child("Groceries/\(userMngr.getGroupId())").observeSingleEvent(of: .value, with: { (snapshot) in
                        let groceryList = snapshot.value as? [String:String] ?? [:]
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
                else{
                    /*************************************
                    *GO TO JOIN CREATE GROUP PAGE
                    **************************************/
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let join_create_grp = storyboard.instantiateViewController(identifier: "registerSuccess")
                                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(join_create_grp)
                }
            })
            
        
            let addCode = userMngr.getGroupId()
        ref.child("Groups/\(addCode)/GroupName").observeSingleEvent(of: .value, with: { (snapshot) in
            if let _groupName = snapshot.value  as? String{
                userMngr.setGroupName(groupname_in: _groupName)//sets username for global user
        
            }
        })
            print("GroupName: \(userMngr.getGroupName())")
            
            completion(true)
        }else{
            //invalidUser.text = "Invalid user"
            completion(false)
        }
        
        userMngr.testInfo(name: "Sign in")

    }
    
    func retrieveGroupName(addCode: String) {
        ref.child("Groups/\(addCode)/GroupName").observeSingleEvent(of: .value, with: { (snapshot) in
            if let group_name = snapshot.value as? String {
                userMngr.setGroupName(groupname_in: group_name)
                print("name: \(group_name)")
            }
        })
    }
}
