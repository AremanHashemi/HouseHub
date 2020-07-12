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

    @IBOutlet weak var inputTextField: UITextField!
    
    private var datePicker: UIDatePicker?
    @IBOutlet var tblTasks: UITableView!//exclamation for null until used
    @IBOutlet var txtTask: UITextField!//chore name
    @IBOutlet var txtDesc: UITextField!//chore description
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(ChoresViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ChoresViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        inputTextField.inputView = datePicker
        
        
        // Do any additional setup after loading the view.
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        userMngr.testInfo(name: "CVC")
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        inputTextField.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    //button click
    @IBAction func btnAddTask_Click(_ sender: UIButton) {
        choreMngr.addChore(name: txtTask.text!, desc: txtDesc.text!)
        let ref = Database.database().reference()
        
        ref.child("Chores/\(userMngr.getGroupId())/\(String(describing: txtTask.text!))/Description").setValue(txtDesc.text)
        ref.child("Chores/\(userMngr.getGroupId())/\(String(describing: txtTask.text!))/Time").setValue(txtDesc.text)
        
        print(datePicker)
        self.view.endEditing(true) //close keyboard
        txtTask.text = "" //make text fields blank
        txtDesc.text = ""
        
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
        
        c_cell.textLabel!.text = choreMngr.chores[indexPath.row].name
        c_cell.detailTextLabel?.text = choreMngr.chores[indexPath.row].desc
        
        return c_cell
    }


}

