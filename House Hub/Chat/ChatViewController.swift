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

class ChatViewController: MessagesViewController {
    
    
    private var messages = [Message]()
    
    private var selfSender: Sender {
        let username = "Me"
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
        let gid = userMngr.getGroupId()
        listenForMessages(id: gid, shouldScrollToBottom: true)
    }
    
    private func listenForMessages(id: String, shouldScrollToBottom: Bool) {
        chatMngr.loadMessages(houseId: id, completion: { [weak self] result in
            switch result {
            case .success(let messages):
                print("Got messages")
                guard !messages.isEmpty else {
                    print("Messages are empty")
                    return
                }
                
                self?.messages = messages
                
                
                DispatchQueue.main.async {
                    self?.messagesCollectionView.reloadDataAndKeepOffset()
                    
                    if shouldScrollToBottom {
                        self?.messagesCollectionView.scrollToBottom()
                    }
                
                }
                
            case .failure(let error):
                print("failed to get messages: \(error)")
            }
            
        })
    }
    


}

extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        
        let selfSender = self.selfSender

        
        
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
        self.messageInputBar.inputTextView.text = nil
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
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        let sender = message.sender
        if sender.senderId == selfSender.senderId {
            return .link
        }

        return .secondarySystemBackground
    }
    
    
}
