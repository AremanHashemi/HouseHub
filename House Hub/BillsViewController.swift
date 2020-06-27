//
//  BillsViewController.swift
//  Task List
//
//  Created by Humza Raza on 6/24/20.
//  Copyright © 2020 dev. All rights reserved.
//

import UIKit

class BillsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    @IBOutlet var tblBills: UITableView!
    @IBOutlet var txtBill: UITextField!
    @IBOutlet var txtDesc: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnAddBill_Click(_ sender: UIButton) {
        billsMngr.addBill(name: txtBill.text!, desc: txtDesc.text!)
        self.view.endEditing(true) //close keyboard
        txtBill.text = "" //make text fields blank
        txtDesc.text = ""
        
        tblBills.reloadData()
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
            billsMngr.bills.remove(at: indexPath.row)
            tblBills.reloadData()
        }
    }
    
    //UItableview data source
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
           return billsMngr.bills.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
           let b_cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "Deault")
           
           b_cell.textLabel!.text = billsMngr.bills[indexPath.row].name
           b_cell.detailTextLabel?.text = billsMngr.bills[indexPath.row].desc
           
           return b_cell
       }
    
    
}

