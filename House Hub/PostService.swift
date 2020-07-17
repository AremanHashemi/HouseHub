//
//  PostService.swift
//  House Hub
//
//  Created by Humza Raza on 7/16/20.
//  Copyright © 2020 dev. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

struct PostService {
    static func createFix(for image: UIImage, imageID: String){
        let imageRef = Storage.storage().reference().child("Fixit/\(userMngr.getGroupId())/\(imageID)")
        StorageService.uploadImage(image, at: imageRef) { (downloadURL) in
            guard let downloadURL = downloadURL else {
                return
            }
            //set url for image
            let urlString = downloadURL.absoluteString
            print("image url: \(urlString)")
        }
    }
    
    static func createProfile(for image: UIImage, imageID: String){
        let imageRef = Storage.storage().reference().child("Users/\(userMngr.getUserId())/\(imageID)")
        StorageService.uploadImage(image, at: imageRef) { (downloadURL) in
            guard let downloadURL = downloadURL else {
                return
            }
            //set url for image
            let urlString = downloadURL.absoluteString
            print("image url: \(urlString)")
        }
    }
}
