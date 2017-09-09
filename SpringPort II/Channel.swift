//
//  Channel.swift
//  SpringPort
//
//  Created by MasterBel2 on 17/9/16.
//  Copyright © 2016 MasterBel2. All rights reserved.
//

import Cocoa

class Channel: NSObject {
    let name: String
    var messages: [Message] = []
    var isDirty: Bool = false // Channels in channellist should be colored when dirty
    var users: [String] = []
    
    init(name: String) {
        self.name = name
    }
    func receivedNewMessage(_ message: Message) {
        messages.append(message)
    }
}
