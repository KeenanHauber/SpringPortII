//
//  Message.swift
//  SpringPort
//
//  Created by MasterBel2 on 17/9/16.
//  Copyright © 2016 MasterBel2. All rights reserved.
//

import Cocoa

class Message {
    let timeStamp: Date
    let sender: String
    let message: String
    let style: String
    
    init(timeStamp: Date, sender: String, message: String, style: String) {
        self.timeStamp = timeStamp
        self.sender = sender
        self.message = message
        self.style = style
    }
}
