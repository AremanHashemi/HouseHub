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
    
    public func getAllUsers(completion: @escaping (Result<[[String: String]], Error>) -> Void) {
        database.child("users").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [[String: String]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }

            completion(.success(value))
        })
    }
    
    public enum DatabaseError: Error {
        case failedToFetch
    }
}

