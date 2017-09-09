//
//  ServerMessage.swift
//  OSXSpringLobby
//
//  Created by Belmakor on 1/07/2016.
//  Copyright © 2016 MasterBel2. All rights reserved.
//

import Foundation

struct ServerMessage {

    enum MessageType: String, RawRepresentable {
        case Broadcast = "BROADCAST"
        case MOTD
        case Server = "SERVERMSG"
    }

    let timeReceived = Date()
    let messageType: MessageType
    let message: String

    init?(type: String, message: String) {
        guard let separatorRange = message.range(of: " ") else { return nil }
        guard let messageType = MessageType(rawValue: type) else { return nil }
        self.messageType = messageType
        self.message = message.substring(from: separatorRange.upperBound)
    }
    
}

extension ServerMessage: CustomStringConvertible {

    var description: String {
        switch messageType {
        case .MOTD: return "MOTD: \(message)"
        case .Server: return message
        case .Broadcast: return "#### \(message)"
        }
    }

}
