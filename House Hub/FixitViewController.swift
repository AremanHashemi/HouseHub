//
//  FixitViewController.swift
//  Task List
//
//  Created by Humza Raza on 6/26/20.
//  Copyright © 2020 dev. All rights reserved.
//

import UIKit

class FixItTableViewCell: UITableViewCell{
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
        addFixView.layer.cornerRadius = 8.0
        addFixView.layer.masksToBounds = true
        addFixView.layer.borderColor = UIColor.black.cgColor
        addFixView.layer.borderWidth = 1.0
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
        fixesMngr.addFix(image: myImageView.image!, desc: txtDesc.text!)
        self.view.endEditing(true) //close keyboard
        txtDesc.text = ""
        myImageView.image = UIImage(named: "InsertImage")
        
        tblFixes.reloadData()
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
        if(editingStyle == UITableViewCell.EditingStyle.delete){
            fixesMngr.fixes.remove(at: indexPath.row)
            tblFixes.reloadData()
        }
    }
    
    //UItableview data source
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
           return fixesMngr.fixes.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
            let f_cell = tableView.dequeueReusableCell(withIdentifier: "FixItCell", for: indexPath) as! FixItTableViewCell

            f_cell.fixItImage.image = fixesMngr.fixes[indexPath.row].image
            f_cell.fixItLabel.text = fixesMngr.fixes[indexPath.row].desc
        
            return f_cell
       }
}
