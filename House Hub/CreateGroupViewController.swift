//
//  CreateGroupViewController.swift
//  House Hub
//
//  Created by Humza Raza on 6/30/20.
//  Copyright © 2020 dev. All rights reserved.
//
import FirebaseAuth
import FirebaseDatabase
import UIKit


class CreateGroupViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        func randomString(length: Int) -> String {
          let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
          return String((0..<length).map{ _ in letters.randomElement()! })
        }
        let code = randomString(length: 5)
        addCodeLabel.text = "\(code)"
    }
    
    @IBOutlet weak var GroupName: UITextField!
    @IBOutlet weak var addCodeLabel: UILabel!
    
//    @IBAction func genCodeBtn(_ sender: Any) {
//
//        func randomString(length: Int) -> String {
//          let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
//          return String((0..<length).map{ _ in letters.randomElement()! })
//        }
//        let code = randomString(length: 5)
//        addCodeLabel.text = "\(code)"
//    }
    @IBAction func CreateBtn(_ sender: Any) {
        //if successful
        //go to tab bar
        let ref = Database.database().reference()
        if(GroupName.text == ""){
            return
        }
        ref.child("Groups/\(addCodeLabel.text!)/Users").setValue(Auth.auth().currentUser?.uid)
        ref.child("Groups/\(addCodeLabel.text!)/GroupName").setValue(GroupName.text!)
        ref.child("users/\(Auth.auth().currentUser!.uid)/Group").setValue(addCodeLabel.text!)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(identifier: "TabBarController")
        
        // This is to get the SceneDelegate object from your view controller
        // then call the change root view controller function to change to main tab bar
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(tabBarController)
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



////
////  CreateGroupViewController.swift
////  House Hub
////
////  Created by Humza Raza on 6/30/20.
////  Copyright © 2020 dev. All rights reserved.
////
//import FirebaseAuth
//import FirebaseDatabase
//import UIKit
//class CreateGroupViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
//
//    @IBOutlet weak var addCodeLabel: UILabel!
//
//    @IBOutlet weak var GroupName: UITextField!
//
//    @IBAction func genCodeBtn(_ sender: Any) {
//
//        func randomString(length: Int) -> String {
//          let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
//          return String((0..<length).map{ _ in letters.randomElement()! })
//        }
//        let code = randomString(length: 5)
//        addCodeLabel.text = "\(code)"
//    }
//    @IBAction func CreateBtn(_ sender: UIButton!) {
//        //if successful
//        //go to tab bar
////        if(addCodeLabel.text == nil || GroupName.text == nil){
////            print("ONE OF THE ITEMS IS NILL \n\n\n\n")
////            return
////        }
////        ref.child("Groups/\(GroupName.text!)/Users").setValue(        Auth.auth().currentUser?.uid)
////        ref.child("Groups/\(GroupName.text!)/AddCode").setValue(addCodeLabel.text)
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let tabBarController = storyboard.instantiateViewController(identifier: "TabBarController")
//
//        // This is to get the SceneDelegate object from your view controller
//        // then call the change root view controller function to change to main tab bar
//        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(tabBarController)
//    }
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
