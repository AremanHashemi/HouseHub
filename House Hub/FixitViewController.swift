//
//  FixitViewController.swift
//  Task List
//
//  Created by Humza Raza on 6/26/20.
//  Copyright © 2020 dev. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import Kingfisher

class FixItTableViewCell: UITableViewCell{
    override func awakeFromNib() {
          super.awakeFromNib()
      }
    
    @IBOutlet var fixItImage: UIImageView!
    @IBOutlet var fixItLabel: UILabel!
}

class FixitViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    
    @IBOutlet var addFixView: UIView!
    @IBOutlet var myImageView: UIImageView!
    @IBOutlet var tblFixes: UITableView!
    @IBOutlet var txtDesc: UITextField!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        myImageView.image = UIImage(named: "InsertImage")//replaces picture with default
        addFixView.layer.cornerRadius = 8.0
        addFixView.layer.masksToBounds = true
        addFixView.layer.borderColor = UIColor.black.cgColor
        addFixView.layer.borderWidth = 1.0
        /****************************************************/
            ref.child("Fixit/\(userMngr.getGroupId())").observe(.value, with: { (snapshot) in
                fixesMngr.fixes.removeAll()
                
                let postDict = snapshot.value as? NSDictionary ?? [:]
                for (id, value1) in postDict{
                    let id:String = id as! String
                    let value = value1 as? [String] ?? nil
                    let desc:String = value![0]
                    let date:String = value![1]
                    let url:String = value![2]
                    fixesMngr.addFix(id: id, date: date, url: url, desc: desc)
                }
                print("sorting pictures")
                fixesMngr.fixes.sort(by: { $0.date > $1.date })
                self.tblFixes.reloadData()

                
                
                self.tblFixes.reloadData()
            })
            self.tblFixes.reloadData()
    }
    
    @IBAction func insertImageBtn(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        if let image = info[.editedImage] as? UIImage{
            myImageView.image = image
        }
        else {
            print("No image found")
            return
        }
    }
    
    @IBAction func btnAddFix_Click(_ sender: UIButton) {
        if txtDesc.text == "" {
            return
        }
        
        let defaultIMG = UIImage(named: "InsertImage")
        
        if defaultIMG?.isEqual(myImageView.image) ?? true {
            print("image not changed")
            return
        }
        
        let desc = txtDesc.text!       //description field
        let imageID = UUID().uuidString //id for image

        //date for when image was added
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let currentDateTime = Date()
        let dateAdded = df.string(from: currentDateTime)

        //store image in storage and info in db on Firebase (calls Storage Service function in storage service class [see file])
        let imageRef = Storage.storage().reference().child("Fixit/\(userMngr.getGroupId())/\(imageID)")
        StorageService.uploadImage(myImageView.image!, at: imageRef) { (downloadURL) in //imageview
            guard let downloadURL = downloadURL else {
                return
            }
            //set url for image
            let imageURL = downloadURL.absoluteString
            //ADD TO DB
            let list = [desc, dateAdded, imageURL]
            ref.child("Fixit/\(userMngr.getGroupId())/\(imageID)").setValue(list)
        }
        //all information saved
        
        
        self.view.endEditing(true) //close keyboard
        txtDesc.text = ""
        myImageView.image = UIImage(named: "InsertImage")//replaces picture with default
    }
    
    //IOS touch fcns
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        textField.resignFirstResponder()
        
        return true
    }
    
    //delete from table
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if((editingStyle == UITableViewCell.EditingStyle.delete) && (fixesMngr.fixes.count > 0)){
            
            let imageRef = Storage.storage().reference().child("Fixit/\(userMngr.getGroupId())/\(fixesMngr.fixes[indexPath.row].id)")
            let fixesRef = ref.child("Fixit/\(userMngr.getGroupId())/\(fixesMngr.fixes[indexPath.row].id)")
            // Delete the file
            imageRef.delete { error in
              if let error = error {
                print(error)
              } else {
                print("image deleted")
              }
            }
            fixesRef.removeValue { error, _ in
                print(error)
            }
            
            
            
            fixesMngr.fixes.remove(at: indexPath.row)
        }
        tblFixes.reloadData()
    }
    
    //UItableview data source
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
           return fixesMngr.fixes.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
            let f_cell = tableView.dequeueReusableCell(withIdentifier: "FixItCell", for: indexPath) as! FixItTableViewCell

           // let imageURL = fixesMngr.fixes[indexPath.row].url
        
            let fix = fixesMngr.fixes[indexPath.row]
            let imageURL = URL(string: fix.url)
            f_cell.fixItImage.kf.setImage(with: imageURL)
            
            f_cell.fixItLabel.text = fixesMngr.fixes[indexPath.row].desc
        
            return f_cell
       }
}
