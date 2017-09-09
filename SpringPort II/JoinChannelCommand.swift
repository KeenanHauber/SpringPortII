//
//  JoinCommand.swift
//  SpringPort
//
//  Created by MasterBel2 on 17/9/16.
//  Copyright © 2016 MasterBel2. All rights reserved.
//

import Cocoa

struct JoinChannelCommand: ServerCommand {
    let chanName: String
    let password: String
    var description: String {
        return "JOIN \(chanName) \(password)"
    }
}
