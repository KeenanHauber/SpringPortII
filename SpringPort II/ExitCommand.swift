//
//  ExitCommand.swift
//  SpringPort
//
//  Created by MasterBel2 on 17/9/16.
//  Copyright © 2016 MasterBel2. All rights reserved.
//

import Cocoa

struct ExitCommand: ServerCommand {
    let reason: String?
    // TODO: Add password capability
    var description: String {
        return "EXIT \(reason)"
    }
}
