//
//  ChatModels.swift
//  House Hub
//
//  Created by Rowen Banton on 7/12/20.
//  Copyright © 2020 dev. All rights reserved.
//

import Foundation
import MessageKit

struct Message: MessageType {
    public var kind: MessageKind
    public var sender: SenderType
    public var messageId: String
    public var sentDate: Date
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
    public var senderId: String
    public var displayName: String
}
