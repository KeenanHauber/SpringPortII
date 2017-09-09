//
//  ChatMessageCommands.swift
//  SpringPort
//
//  Created by MasterBel2 on 20/9/16.
//  Copyright © 2016 MasterBel2. All rights reserved.
//

import Foundation

struct SayCommand: ServerCommand {
    let chanName: String
    let message: String
    var description: String {
        return "SAY \(chanName) \(message)"
    }
}

struct SayexCommand: ServerCommand {
    let chanName: String
    let message: String
    var description: String {
        return "SAYEX \(chanName) \(message)"
    }
}

