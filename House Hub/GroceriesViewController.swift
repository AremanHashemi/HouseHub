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
    
    /***********************************
* DO BEFORE SHOWING
    ************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ref.child("Groceries/\(userMngr.getGroupId())").observe(.value, with: { (snapshot) in
            groceryMngr.groceries.removeAll()
            print("Grocceries getting updated")
            print(userMngr.getGroupId())
            print("Snapshot =", snapshot)
            //groceryMngr.groceries.removeAll()
            let groceryList = snapshot.value as? [String:String] ?? [:]
            let sortedGroceryList = groceryList.sorted(by: <)
            for (name, desc) in sortedGroceryList{
                print(name, desc)
                groceryMngr.addGrocery(name: name, desc: desc)
            }
            self.tblGroceries.reloadData()
        })
        self.tblGroceries.reloadData()
    }

    /***********************************
    * DO WHEN SWITCHING BACK
    ************************************/
    override func viewWillAppear(_ animated: Bool){
         tblGroceries.reloadData()
    }

    /***********************************
    * ADDS TO GROCERY LIST
    ************************************/
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
    
    /***********************************
    * IOS TOUCH FUNCTIONS
    ************************************/
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        textField.resignFirstResponder()
        
        return true
    }
    
    /***********************************
    * DELETE FROM TABLE
    ************************************/
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if(editingStyle == UITableViewCell.EditingStyle.delete){
            groceryMngr.groceries.remove(at: indexPath.row)
            tblGroceries.reloadData()
        }
    }
    
    func refresh2 (){
        self.tblGroceries.reloadData()
    }
    
    /***********************************
    * TABLE DATA SOURCE
    ************************************/
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

