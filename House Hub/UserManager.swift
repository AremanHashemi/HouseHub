//
//  UserManager.swift
//  Task List
//
//  Created by Humza Raza on 7/8/20.
//  Copyright © 2020 dev. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

var userMngr: UserManager = UserManager()

class UserManager: NSObject {
    private var username = ""
    private var userId = ""
    private var groupname = ""
    private var groupId = ""
    private var housemates: [String] = []
    
    /***********************************
    * SETTERS
    ************************************/
    func setUserId(userId_in: String){
        userId = userId_in
    }
    
    func setUserName(username_in: String){
        username = username_in
    }
    
    func setGroupName(groupname_in: String){
        groupname = groupname_in
    }
    
    func setGroupId(groupId_in: String){
        groupId = groupId_in
    }
    
    func setHouseMates(housemates_in: [String]){
        //set housemates here
    }
    
    /***********************************
    * GETTERS
    ************************************/
    func getUserId() -> String{
        return userId
    }
    
    func getUserName() -> String{
        return username
    }
    
    func getGroupId() -> String{
        return groupId
    }
    
    func getGroupName() -> String{
        return groupname
    }
    
    func getHouseMates() -> [String]{
        return housemates
    }
    
    public func retGroupName(addCode: String) {
        ref.child("Groups/\(addCode)/GroupName").observeSingleEvent(of: .value, with: { (snapshot) in
            let group_name = snapshot.value as? String
            //userMngr.setGroupName(groupname_in: groupname!)
            //                  print("Group Name: \(userMngr.getGroupName())")
            self.groupname = group_name!
        })
    }
    
    // testing
    func testInfo(name: String) {
        print("----\(name)-----")
        print("Name: \(userMngr.getUserName())")
        print("UID: \(userMngr.getUserId())")
        print("GName: \(self.groupname)")
        print("GID: \(userMngr.getGroupId())")
        print("Housemates: \(userMngr.getHouseMates())")
        print("---------------")
    }

}
