//
//  ChoresViewController.swift
//  Task List
//
//  Created by Humza Raza on 6/24/20.
//  Copyright © 2020 dev. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ChoresViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    @IBOutlet var tblTasks: UITableView!//exclamation for null until used
    @IBOutlet var txtChoreName: UITextField!
    @IBOutlet var txtAssignto: UITextField!
    @IBOutlet var txtDeadline: UITextField!
    
    private var datePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(BillsViewController.dateChanged(datePicker:)), for: .valueChanged)
        txtDeadline.inputView = datePicker
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
   //     print("=\(userMngr.getGroupName())")
        userMngr.testInfo(name: "CVC")
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/dd/yy"
        
        txtDeadline.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    //button click
    @IBAction func btnAddTask_Click(_ sender: UIButton) {
        var deadline = ""
        if let field = txtDeadline.text, field.isEmpty {
          deadline = "NONE"
           // print(deadline)
        } else {
            deadline = txtDeadline.text!
            //print(deadline)
        }
        
        choreMngr.addChore(choreName: txtChoreName.text!, chorePerson: txtAssignto.text!, deadline: deadline, username: userMngr.getUserName())
        
        
//        let ref = Database.database().reference()
//
//        ref.child("Chores/\(userMngr.getGroupId())/\(String(describing: txtChoreName.text!))/AssignedTo").setValue(txtAssignto.text)
//        ref.child("Chores/\(userMngr.getGroupId())/\(String(describing: txtChoreName.text!))/Deadline").setValue(txtDeadline.text)
        
        txtChoreName.text = "" //make text fields blank
        txtAssignto.text = ""
        txtDeadline.text = ""
        
        tblTasks.reloadData()
    }
    //
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
        self.view.endEditing(true) //close keyboard
        if(editingStyle == UITableViewCell.EditingStyle.delete){
            choreMngr.chores.remove(at: indexPath.row)
            tblTasks.reloadData()
        }
    }
    
    //UItableview data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return choreMngr.chores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let c_cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "Deault")
         c_cell.textLabel?.numberOfLines = 0;
        
        let cell_text = choreMngr.chores[indexPath.row].choreName + " \nAssigned To: " + choreMngr.chores[indexPath.row].chorePerson + " \nDeadline: " + choreMngr.chores[indexPath.row].deadline
        
        c_cell.textLabel!.text = cell_text
        c_cell.detailTextLabel?.text = "Added by " + choreMngr.chores[indexPath.row].username
        
        if(choreMngr.chores[indexPath.row].deadline != "NONE"){
            
            /**********************************
             *DUE DATE
             *********************************/
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M/dd/yy"
            let date = dateFormatter.date(from: choreMngr.chores[indexPath.row].deadline)
           
            /*********************************
             *TODAYS DATE
             ********************************/
            let currentDateTime = Date()
            let today = dateFormatter.string(from: currentDateTime)
            let today_date = dateFormatter.date(from: today)

            if((date! < today_date!)){//compare dates green if not due yet red if overdue yellow if due today
                c_cell.backgroundColor = UIColor.systemRed
            }
            else if((date! == today_date!)){
                c_cell.backgroundColor = UIColor.systemYellow
            }
            else{
                c_cell.backgroundColor = UIColor.systemGreen
            }
        }
        else{
            c_cell.backgroundColor = UIColor.systemGreen
        }
        
        return c_cell
    }


}

