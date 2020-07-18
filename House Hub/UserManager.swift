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
    private var photoId = ""
    private var photoUrl = ""
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
    
    func setPhotoId(photoId_in: String){
        photoId = photoId_in
    }
    
    func setPhotoUrl(photoUrl_in: String){
        photoUrl = photoUrl_in
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
    
    func getPhotoId() -> String{
        return photoId
    }
    
    func getPhotoUrl() -> URL{
        let url = URL(string: photoUrl)!
        return url
    }
    
    func getHouseMates() -> [String]{
        return housemates
    }
    
    public func retGroupName(addCode: String) {
        var gname = "test"
        ref.child("Groups/\(addCode)/GroupName").observeSingleEvent(of: .value, with: { (snapshot) in
            let group_name = snapshot.value as? String
            gname = group_name!
     //       print("gname inside: \(group_name!)")
            self.groupname = group_name!
   //         print("retGN: \(self.getGroupName())")
        })
        
  //      print("Setting gname to: \(gname)")
        self.setGroupName(groupname_in: gname)
    }
    
    // testing
    public func testInfo(name: String) {
        print("----\(name)-----")
        print("Name: \(userMngr.getUserName())")
        print("UID: \(userMngr.getUserId())")
        print("GName: \(userMngr.getGroupName())")
        print("GID: \(userMngr.getGroupId())")
        print("---------------")
    }
}
