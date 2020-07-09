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

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

class ChatViewController: MessagesViewController {
    
    private var messages = [Message]()
    
    private let selfSender = Sender(senderId: "1",
                                    displayName: "Rowen Banton")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .link
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back",
//                                                           style: .done,
//                                                           target: self,
//                                                           action: #selector(didClickBack))
        
        // loadChat
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self

        }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
 //       messageInputBar.inputTextView.becomeFirstResponder()
    }
    
    // Need some way to return to the app since nav bar doesnt show up
//    @objc private func didClickBack() {
//        let vc = GroceriesViewController()
//        present(vc, animated: true)
//
//    }
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
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
