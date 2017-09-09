//
//  LeaveChannelCommand.swift
//  SpringPort
//
//  Created by MasterBel2 on 19/9/16.
//  Copyright © 2016 MasterBel2. All rights reserved.
//

import Foundation

struct LeaveChannelCommand: ServerCommand {
    let chanName: String
    var description: String {
        return "LEAVE \(chanName)"
    }
}
