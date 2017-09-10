//
//  PrivateMessageCoordinator.swift
//  SpringPort II
//
//  Created by MasterBel2 on 7/4/17.
//  Copyright © 2017 MasterBel2. All rights reserved.
//

import Foundation

class Conversation {
    let conversee: String
    var dirty: Bool
    var messages: [Message] = []
    init(with conversee: String) {
        self.conversee = conversee
        dirty = true
    }
    func new(_ message: Message) {
        messages.append(message)
    }
}

protocol PrivateMessageDataOutput: class {
    func update(_ conversation: Conversation)
    func new(_ conversation: Conversation)
}

class PrivateMessageCoordinator: ServerPrivateMessageDelegate {
    var conversations: [Conversation] = []
    weak var output: PrivateMessageDataOutput?
    
    // MARK: - ServerPrivateMessageDelegate
    
    func server(_ server: TASServer, didRecieve privateMessage: String, from sender: String, of type: MessageType) {
        var style: String {
            switch type {
            case .IRCStyle:
                return "IRCStyle"
            case .Standard:
                return "Standard"
            }
        }
        let message = Message(timeStamp: timeStamp(), sender: sender, message: privateMessage, style: style)
        guard let conversation = (conversations.filter { $0.conversee == sender }).first else {
            let conversation = Conversation(with: sender)
            conversation.new(message)
            conversations.append(conversation)
            output?.new(conversation)
            
            return
        }
        
        conversation.new(message)
        output?.update(conversation)
        return
    }
}
