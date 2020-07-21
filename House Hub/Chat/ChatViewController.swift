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
import SDWebImage

class ChatViewController: MessagesViewController {
    
    let defaultURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/househub-a961b.appspot.com/o/Users%2Fdefault%2Fdefault?alt=media&token=5b7b4873-3671-40fa-8428-4c02549e53c0")!
    
    private var messages = [Message]()
    
    private var myURL: URL?
    
    private var selfSender: Sender {
        let username = "Me"
        let userID = userMngr.getUserId()
        let url = userMngr.getPhotoUrl()
        
        return Sender(senderId: userID,
                      displayName: username,
                      photoURL: url)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .link
        
        // loadChat
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
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
    
    func shouldDisplayHeader(index: Int) -> Bool {
        var shouldDisplayHeader = false
        if(index == 0) {
            shouldDisplayHeader = true
        } else {
            let prevMsg = messages[index - 1]
            let prevId = prevMsg.sender.senderId
            if messages[index].sender.senderId != prevId {
                shouldDisplayHeader = true
            } else {
                shouldDisplayHeader = false
            }
        }
        return shouldDisplayHeader
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
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        let sender = message.sender
        
        if sender.senderId == selfSender.senderId {
            myURL = selfSender.photoURL
            avatarView.sd_setImage(with: myURL, completed: nil)
        } else {
            let id = sender.senderId
            ref.child("users/\(id)/photoURL").observeSingleEvent(of: .value, with: { snapshot in
                let url = snapshot.value as? String
                if url != nil {
                    let otherURL = URL(string: url!)
                    avatarView.sd_setImage(with: otherURL, completed: nil)
                } else {
                    avatarView.sd_setImage(with: self.defaultURL, completed: nil)
                }
                
            })
        }
    }
    
    func messageHeaderView(for indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageReusableView {
        let header = messagesCollectionView.dequeueReusableHeaderView(HeaderReusableView.self, for: indexPath)
        let displayHeader = shouldDisplayHeader(index: indexPath.section)
        if (displayHeader) {
            let message = messageForItem(at: indexPath, in: messagesCollectionView)
            header.setup(with: message.sender.displayName)
        }
        return header
    }
    
    func headerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        let displayHeader = shouldDisplayHeader(index: section)
        if (displayHeader) {
            return CGSize(width: messagesCollectionView.bounds.width, height: HeaderReusableView.height)
        } else {
            return .zero
        }
    }
    
    
}
