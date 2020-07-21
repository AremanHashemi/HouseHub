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
        //get housemates list
        let myRef = Database.database().reference().child("Groups/\(userMngr.getGroupId())")
            myRef.observe(.value, with: { (snapshot) in
             housematesMngr.housemates.removeAll()
             
            if !snapshot.exists() {//dont do anything if there isnt data
                return
            }
                
             let groupData = snapshot.value as! [String: Any]
             let userDictionary = groupData["Users"] as! [String: String]
             
             //iterates through the housemates dictionary id is the user id and the "key", name is the username and the "value"
             for (id, name) in userDictionary {
                 _ = ref.child("users").child(id).child("photoURL").observe(.value, with: { (snapshot) in
                     
                     if !snapshot.exists() {
                         let url = "https://firebasestorage.googleapis.com/v0/b/househub-a961b.appspot.com/o/Users%2Fdefault%2Fdefault?alt=media&token=5b7b4873-3671-40fa-8428-4c02549e53c0"
                         housematesMngr.addHousemate(name: name, url: url)
                     }
                     if let url = snapshot.value  as? String{
                         housematesMngr.addHousemate(name: name, url: url)
                     }
                    housematesMngr.housemates.sort(by: { $0.name < $1.name })
                 })
             }
         })
        
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(BillsViewController.dateChanged(datePicker:)), for: .valueChanged)
        txtDeadline.inputView = datePicker
        ref.child("Chores/\(userMngr.getGroupId())").observe(.value, with: { (snapshot) in
            choreMngr.chores.removeAll()
            
            if !snapshot.exists() {//dont do anything if there isnt data
                return
            }
            
            let postDict = snapshot.value as? NSDictionary ?? [:]
            for (name, value1) in postDict{
                let name:String = name as! String
                let value = value1 as? [String] ?? nil
                let chorePerson:String = value![0]
                let deadline:String = value![1]
                let username:String = value![2]
                choreMngr.addChore(choreName: name, chorePerson: chorePerson, deadline: deadline, username: username)
            }
                self.tblTasks.reloadData()
        })
        self.tblTasks.reloadData()
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
            let ChoresRef = ref.child("Chores/\(userMngr.getGroupId())/\(choreMngr.chores[indexPath.row].choreName)")
            ChoresRef.removeValue()
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
                c_cell.backgroundColor = UIColor(red: 1, green: 0.6588, blue: 0.6588, alpha: 0.5)
            }
            else if((date! == today_date!)){
                c_cell.backgroundColor = UIColor(red: 0.9922, green: 1, blue: 0.6588, alpha: 0.5)
            }
            else{
                c_cell.backgroundColor = UIColor(red: 0.7137, green: 1, blue: 0.6588, alpha: 0.5)
            }
        }
        else{
            c_cell.backgroundColor = UIColor(red: 0.7137, green: 1, blue: 0.6588, alpha: 0.5)
        }
           return c_cell
       }
}
