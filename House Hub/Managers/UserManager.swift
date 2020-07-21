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
    private var memberId = ""
    private var groupId = ""
    private var photoId = "default"
    private var photoUrl = "https://firebasestorage.googleapis.com/v0/b/househub-a961b.appspot.com/o/Users%2Fdefault%2Fdefault?alt=media&token=5b7b4873-3671-40fa-8428-4c02549e53c0"
    public var housemates: [String: String] = [:]
    
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
   
    func setmemberId(memberId_in: String){
        userId = memberId_in
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
    
    func setHouseMates(housemates_in: [String:String]){
        housemates = housemates_in
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
    
    func getmemberId() -> String{
        return memberId
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
    
    func getUrlString() -> String {
        return photoUrl
    }
    
    func getHouseMates() -> [String:String]{
        return housemates
    }
    
    public func retGroupName(addCode: String) {
        var gname = "test"
        ref.child("Groups/\(addCode)/GroupName").observeSingleEvent(of: .value, with: { (snapshot) in
            let group_name = snapshot.value as? String
            self.groupname = group_name!
            userMngr.setGroupName(groupname_in: group_name!)
        })
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
    
    public func buildHouse(addCode: String) {
        ref.child("Groups/\(addCode)/Users").observeSingleEvent(of: .value, with: { snapshot in
            guard let users = snapshot.value as? [String] else {
                print("Couldn't get housemates")
                return
            }
            
            print("Housemates: \(users)")
            
            for uid in users {
                userMngr.buildHousemate(id: uid)
            }
            
        })
    }
    
    public func buildHousemate(id: String) {
        print("id: \(id)")
        
        ref.child("users").child(id).child("photoURL").observeSingleEvent(of: .value, with: { (snapshot) in
            if let photoURL = snapshot.value  as? String {
                print("URL: \(photoURL)")
            } else {
                print("Couldn't get url")
            }
        })
        
        ref.child("users/\(id)/user").observeSingleEvent(of: .value, with: { snapshot in
            guard let name = snapshot.value as? String else {
                print("Couldn't get housemate name")
                return
            }
            
            print("Name: \(name)")
            
        })
    
    }
}

struct User {
    public var name: String
    public var photoUrl: URL
}

struct HouseMembers {
    public var members = [User]()
}
