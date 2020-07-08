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
    @IBOutlet var txtPrice: UITextField!
    @IBOutlet var txtDeadline: UITextField!
    @IBOutlet var txtSplit: UITextField!
    
    private var datePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(BillsViewController.dateChanged(datePicker:)), for: .valueChanged)
        txtDeadline.inputView = datePicker
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/dd/yy"
        
        txtDeadline.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    @IBAction func btnAddBill_Click(_ sender: UIButton) {
        var split = 1.0//no split
  
        if ((txtBill.text == "") || (txtPrice.text == "")) {//price is required and name of bill is required
            return
        }
        else if((txtSplit.text != "") && (Double(txtSplit.text!)! > 1)){//if no split was entered or 0 was enterred then no split
            split = Double(txtSplit.text!)!
        }
        
        var deadline = ""
        if let field = txtDeadline.text, field.isEmpty {
          deadline = "NONE"
           // print(deadline)
        } else {
            deadline = txtDeadline.text!
            //print(deadline)
        }

        
        let price = Double(txtPrice.text!)!
        let price_per_person = price/split
        let price_per_person_txt = String(format: "%.2f", price_per_person) // rounded to 2 decimal places
        
        billsMngr.addBill(name: txtBill.text!, price: txtPrice.text!, split: price_per_person_txt, deadline: deadline, username: userMngr.getUserName())
        self.view.endEditing(true) //close keyboard
        txtBill.text = "" //make text fields blank
        txtPrice.text = ""
        txtDeadline.text = ""
        txtSplit.text = ""
        
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
            b_cell.textLabel?.numberOfLines = 0;

        let cell_text = billsMngr.bills[indexPath.row].name + " \nTotal: $" + billsMngr.bills[indexPath.row].price + " \nAmount Per Person: $" + billsMngr.bills[indexPath.row].split + " \nDue Date: " + billsMngr.bills[indexPath.row].deadline
          
        b_cell.textLabel!.text = cell_text
        b_cell.detailTextLabel?.text = "Added by " + billsMngr.bills[indexPath.row].username
        
        
        if(billsMngr.bills[indexPath.row].deadline != "NONE"){
            
            /**********************************
             *DUE DATE
             *********************************/
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M/dd/yy"
            let date = dateFormatter.date(from: billsMngr.bills[indexPath.row].deadline)
           
            /*********************************
             *TODAYS DATE
             ********************************/
            let currentDateTime = Date()
            let today = dateFormatter.string(from: currentDateTime)
            let today_date = dateFormatter.date(from: today)

            if((date! < today_date!)){//compare dates green if not due yet red if overdue yellow if due today
                b_cell.backgroundColor = UIColor.systemRed
            }
            else if((date! == today_date!)){
                b_cell.backgroundColor = UIColor.systemYellow
            }
            else{
                b_cell.backgroundColor = UIColor.systemGreen
            }
        }
        else{
            b_cell.backgroundColor = UIColor.systemGreen
        }
           return b_cell
       }
    
    
}

