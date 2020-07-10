//
//  ChatDatabaseManager.swift
//  House Hub
//
//  Created by Rowen Banton on 7/8/20.
//  Copyright © 2020 dev. All rights reserved.
//

import Foundation
import FirebaseDatabase

var chatMngr: ChatDatabaseManager = ChatDatabaseManager()

final class ChatDatabaseManager {
    
    private let ref = Database.database().reference()
    
    public static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        return formatter
    }()
    
    
    public func createNewConversation(addCode: String, firstMessage: Message, completion: @escaping (Bool) -> Void) {
        let dateString = Self.dateFormatter.string(from: firstMessage.sentDate)
        var message = ""
       
        switch firstMessage.kind {
        case .text(let messageText):
            message = messageText
        case .attributedText(_):
            break
        case .photo(_):
            break
        case .video(_):
            break
        case .location(_):
            break
        case .emoji(_):
            break
        case .audio(_):
            break
        case .contact(_):
            break
        case .custom(_):
            break
        }
        
        let collectionMessage: [String: Any] = [
            "id": firstMessage.messageId,
            "type": firstMessage.kind.messageKindString,
            "content": message,
            "date": dateString,
            "senderId": userMngr.getUserId(),
        ]
        
        let value: [String: Any] = [
            "messages": [
                collectionMessage
            ]
        ]
    
        let header = "groupchat_\(addCode)"
        print("Adding convo \(header)")
        //        ref.child("users/\(Auth.auth().currentUser!.uid)/Group").setValue(addCodeLabel.text!)
   
        ref.child("Groupchats/\(header)").setValue(value, withCompletionBlock: { error, _ in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        })
    }
    
    public func createMessageId() -> String {
        let dateString = Self.dateFormatter.string(from: Date())
        let uid = userMngr.getUserId()
        let msgIdentifier = "\(uid)_\(dateString)"
        return msgIdentifier
    }
}

