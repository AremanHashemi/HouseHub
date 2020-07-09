//
//  ChatDatabaseManager.swift
//  House Hub
//
//  Created by Rowen Banton on 7/8/20.
//  Copyright © 2020 dev. All rights reserved.
//

import Foundation
import FirebaseDatabase

final class ChatDatabaseManager {
    
    private let database = Database.database().reference()
    
    
    public enum DatabaseError: Error {
        case failedToFetch
    }
}

