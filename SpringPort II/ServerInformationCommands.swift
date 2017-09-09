//
//  ServerInformationCommands.swift
//  SpringPort II
//
//  Created by MasterBel2 on 4/1/17.
//  Copyright © 2017 MasterBel2. All rights reserved.
//

import Foundation
struct GetIngameTimeCommand: ServerCommand {
    var description: String {
        return "GETINGAMETIME"
    }
}
