//

// CLEAN HH


//  MessagesViewController.swift
//  Task List
//
//  Created by Humza Raza on 6/26/20.
//  Copyright © 2020 dev. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

struct Message: MessageType {
    var kind: MessageKind
    var sender: SenderType
    var messageId: String
    var sentDate: Date
//    var kind: MessageKind
}

extension MessageKind {
    var messageKindString: String {
        switch self {
        case .text(_):
            return "text"
        case .attributedText(_):
            return "attributed_text"
        case .photo(_):
            return "photo"
        case .video(_):
            return "video"
        case .location(_):
            return "location"
        case .emoji(_):
            return "emoji"
        case .audio(_):
            return "audio"
        case .contact(_):
            return "contact"
        case .custom(_):
            return "customc"
        }
    }
}

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

class ChatViewController: MessagesViewController {
    
    
    private var messages = [Message]()
    

    
    private var selfSender: Sender {
        let username = userMngr.getUserName()
        let userID = userMngr.getUserId()
        
        return Sender(senderId: userID,
               displayName: username)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .link
        
        // loadChat
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self

        }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
    }
    


}

extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
//        guard let selfSender = self.selfSender as? Sender else {
//            print("Sender is nil")
//            return
//        }
        
        let selfSender = self.selfSender

        
//        guard let addcode = userMngr.getGroupId() as? String else {
//            print ("Add code empty")
//            return
//        }
        
        let addcode = userMngr.getGroupId()
        
        let name = selfSender.displayName
        let uid = selfSender.senderId
        print("Name: \(name)")
        print("UID: \(uid)")
        
        
        let message = Message(kind: .text(text),
                              sender: selfSender,
                              messageId: chatMngr.createMessageId(),
                              sentDate: Date())
        
        chatMngr.sendMessage(addCode: addcode,
                             newMessage: message,
                             completion: { success in
                                if success {
                                    print("Message \"\(text)\" sent to group \(addcode)")
                                } else {
                                    print("Failed to send message")
                                }
        })
        
        print("Sending: \(text)")
    }
}

extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        return selfSender
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
}
