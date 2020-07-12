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
    
    public enum ChatDatabaseError: Error {
        case failedToFetch
    }
    
    public func loadMessages(houseId: String, completion: @escaping (Result<[Message], Error>) -> Void) {
        ref.child("GroupChats/groupchat_MKFOP/messages").observe(.value, with: { (snapshot) in
            print("Here1")
            guard let value = (snapshot.value  as? [[String: Any]]) else {
                completion(.failure(ChatDatabaseError.failedToFetch))
                return
            }
            
            print("Here2")
            
            let messages: [Message] = value.compactMap({ dictionary in
                guard let messageID = dictionary["id"] as? String,
                    let content = dictionary["content"] as? String,
                    let type = dictionary["type"] as? String,
                    let dateString = dictionary["date"] as? String,
                    let senderID = dictionary["senderId"] as? String,
                    let senderName = dictionary["senderName"] as? String,
                    let date = ChatDatabaseManager.dateFormatter.date(from: dateString) else {
                        return nil
                }
                
                let sender = Sender(senderId: senderID,
                                    displayName: senderName)
                
                print("MESSAGE RETRIEVED: \(content)")
                
                return Message(kind: .text(content),
                               sender: sender,
                               messageId: messageID,
                               sentDate: date)
                
            })
            completion(.success(messages))
        })
    }
    
    
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
        
        print("\(userMngr.getUserName())")
        
        let collectionMessage: [String: Any] = [
            "id": firstMessage.messageId,
            "type": firstMessage.kind.messageKindString,
            "content": message,
            "date": dateString,
            "senderId": userMngr.getUserId(),
            "senderName": firstMessage.sender.displayName
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
    
    public func sendMessage(addCode: String, newMessage: Message, completion: @escaping (Bool) -> Void) {
        let header = "groupchat_\(addCode)"
        ref.child("Groupchats/\(header)/messages").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let strongSelf = self else {
                return
            }
            
            guard var currentMessages = snapshot.value as? [[String: Any]] else {
                completion(false)
                print("Couldn't get messages")
                return
            }
            
            let dateString = Self.dateFormatter.string(from: newMessage.sentDate)
            var message = ""
            switch newMessage.kind {
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
            
            let newMessageEntry: [String: Any] = [
                "id": newMessage.messageId,
                "type": newMessage.kind.messageKindString,
                "content": message,
                "date": dateString,
                "senderId": userMngr.getUserId(),
                "senderName": newMessage.sender.displayName
            ]
            
            currentMessages.append(newMessageEntry)
            
            strongSelf.ref.child("Groupchats/\(header)/messages").setValue(currentMessages) { error, _ in
                guard error == nil else {
                    completion(false)
                    return
                }
                
            }
            
        })
    }
    
    public func createMessageId() -> String {
        let dateString = Self.dateFormatter.string(from: Date())
        let uid = userMngr.getUserId()
        let msgIdentifier = "\(uid)_\(dateString)"
        return msgIdentifier
    }

    public func sendCreateGroupMessage(addCode: String) {
        let name = userMngr.getUserName()
        let userid = userMngr.getUserId()
        let gname = userMngr.getGroupName()
        let content = "AUTO: \(name) has created \(gname)"
        
        let sender = Sender(senderId: userid,
                            displayName: name)
        
        let message = Message(kind: .text(content),
                              sender: sender,
                              messageId: chatMngr.createMessageId(),
                              sentDate: Date())
        
        chatMngr.createNewConversation(addCode: addCode, firstMessage: message, completion: { success in
            if success {
                print("Create message sent")
            } else {
                print("Failed to notify creating member")
            }
        })
    }
    
    public func sendJoinGroupMessage(addCode: String) {
        let name = userMngr.getUserName()
        let userid = userMngr.getUserId()
        let content = "AUTO: \(name) has joined \(userMngr.getGroupName())"
        let sender = Sender(senderId: userid,
                            displayName: name)
        
        let message = Message(kind: .text(content),
                              sender: sender,
                              messageId: chatMngr.createMessageId(),
                              sentDate: Date())
        
        chatMngr.sendMessage(addCode: addCode, newMessage: message, completion: { success in
            if success {
                print("Join message sent")
            } else {
                print("Failed to notify joining member")
            }
        })
    }
    
    public func sendLeaveGroupMessage(addCode: String) {
        let name = userMngr.getUserName()
        let userid = userMngr.getUserId()
        let content = "AUTO: \(name) has left \(userMngr.getGroupName())"
        let sender = Sender(senderId: userid,
                            displayName: name)
        
        let message = Message(kind: .text(content),
                              sender: sender,
                              messageId: chatMngr.createMessageId(),
                              sentDate: Date())
        
        chatMngr.sendMessage(addCode: addCode, newMessage: message, completion: { success in
            if success {
                print("Leave message sent")
            } else {
                print("Failed to notify joining member")
            }
        })
    }
}
