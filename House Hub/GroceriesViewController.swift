//
//  GroceriesViewController.swift
//  Task List
//
//  Created by Humza Raza on 6/24/20.
//  Copyright © 2020 dev. All rights reserved.
//

import UIKit
import FirebaseDatabase

class GroceriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    @IBOutlet var tblGroceries: UITableView!
    @IBOutlet var txtGrocery: UITextField!
    @IBOutlet var txtDesc: UITextField!

     override func viewWillAppear(_ animated: Bool){
          let ref = Database.database().reference()
                ref.child("Groceries/test-group").observeSingleEvent(of: .value, with: { (snapshot) in
                    let groceryList = snapshot.value as? [String:String] ?? [:]
                    print(groceryList)
                    for (name, desc) in groceryList{
                        groceryMngr.addGrocery(name: name, desc: desc)
                    }
                })
                tblGroceries.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let ref = Database.database().reference()
        ref.child("Groceries/test-group").observeSingleEvent(of: .value, with: { (snapshot) in
            let groceryList = snapshot.value as? [String:String] ?? [:]
            print(groceryList)
            for (name, desc) in groceryList{
                groceryMngr.addGrocery(name: name, desc: desc)
            }
        })
        tblGroceries.reloadData()
    }
       
    //button click
    @IBAction func btnAddGrocery_Click(_ sender: UIButton) {
        if txtGrocery.text == "" {
            return
        }
        groceryMngr.addGrocery(name: txtGrocery.text!, desc: txtDesc.text!)
        self.view.endEditing(true) //close keyboard
        txtGrocery.text = "" //make text fields blank
        txtDesc.text = ""
        tblGroceries.reloadData()
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
            groceryMngr.groceries.remove(at: indexPath.row)
            tblGroceries.reloadData()
        }
    }
    
    //UItableview data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return groceryMngr.groceries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let g_cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "Deault")
        
        g_cell.textLabel!.text = groceryMngr.groceries[indexPath.row].name
        g_cell.detailTextLabel?.text = groceryMngr.groceries[indexPath.row].desc
        
        return g_cell
    }
    
}

