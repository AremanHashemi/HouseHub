//
//  ProfileViewController.swift
//  Task List
//
//  Created by Humza Raza on 6/26/20.
//  Copyright © 2020 dev. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Kingfisher

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var groupCode: UILabel!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var pfp: UIImageView!
    
    let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //load profile picture
        pfp.kf.setImage(with: userMngr.getPhotoUrl())

        pfp.layer.cornerRadius = pfp.frame.height/2

        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let profName = value?["user"] as? String ?? ""
            let gc = value?["Group"] as? String ?? ""
            self.profileName.text = profName + "'s " + self.profileName.text!
            self.groupCode.text = self.groupCode.text! + " " + gc
            // ...
            }) { (error) in
                print(error.localizedDescription)
            }
        
        ref.child("Groups").child(userMngr.getGroupId()).observeSingleEvent(of: .value, with: { (snapshot) in
        // Get user value
        let value = snapshot.value as? NSDictionary
        let gn = value?["GroupName"] as? String ?? ""
        self.groupName.text = gn
        // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    @IBAction func addPfp(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    @IBAction func uploadPicture(_ sender: Any) {
        let storageRef = Storage.storage().reference().child("Users/\(userMngr.getUserId())/\(userMngr.getPhotoId())")
       // Delete the file from storage
       storageRef.delete { error in
        if error != nil {
           print("nothing deleted")
         } else {
           print("image deleted")
         }
       }
        
        let imageID = UUID().uuidString //id for image
        userMngr.setPhotoId(photoId_in: imageID)
        
        //store image in storage and info in db on Firebase (calls Storage Service function in storage service class [see file])
               let imageRef = Storage.storage().reference().child("Users/\(userMngr.getUserId())/\(imageID)")
               StorageService.uploadImage(pfp.image!, at: imageRef) { (downloadURL) in //imageview
                   guard let downloadURL = downloadURL else {
                       return
                   }
                   //set url for image
                   let imageURL = downloadURL.absoluteString
                   userMngr.setPhotoUrl(photoUrl_in: imageURL)
                   //ADD TO DB
                   self.ref.child("users").child(Auth.auth().currentUser!.uid).child("photoURL").setValue(imageURL)
                self.ref.child("users").child(Auth.auth().currentUser!.uid).child("photoID").setValue(imageID)
                print("profile uploaded")
               }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        if let image = info[.editedImage] as? UIImage{
            pfp.image = image
        }
        else {
            print("No image found")
            return
        }
    }
    
    @IBAction func changeUserBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "ChangeUserVC")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
    }
    
    @IBAction func changePassBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "ChangePassVC")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
    }
    
    @IBAction func leaveGroupBtn(_ sender: Any) {
        let userID = Auth.auth().currentUser?.uid
        
        /*************************************
        *SEND LEAVE MESSAGE
        **************************************/
        let gid = userMngr.getGroupId()
        chatMngr.sendLeaveGroupMessage(addCode: gid)
        
        
        ref.child("users/\(userID!)/Group").removeValue()
        userMngr.setGroupId(groupId_in: "")
        /*************************************
        *EMPTY LOCAL LISTS
        **************************************/
        groceryMngr.groceries.removeAll()
        choreMngr.chores.removeAll()
        billsMngr.bills.removeAll()
        fixesMngr.fixes.removeAll()
        /*************************************
        *GO TO JOIN CREATE GROUP PAGE
        **************************************/
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let join_create_grp = storyboard.instantiateViewController(identifier: "registerSuccess")
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(join_create_grp)
   
    }
        
    @IBAction func logoutBtn(_ sender: Any) {
        
          // ...
              // after user has successfully logged out
        do {
            try Auth.auth().signOut()
        }
        catch let signOutError as NSError {
            print("error signing out: %@", signOutError)
        }
        
        /*************************************
        *EMPTY LOCAL LISTS
        **************************************/
        groceryMngr.groceries.removeAll()
        
        /*************************************
        *GO TO LOG IN SCREEN
        **************************************/
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
        
    }
    
    @IBAction func backBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "TabBarController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
    }
}
