//
//  ToSortCommands.swift
//  SpringPort II
//
//  Created by MasterBel2 on 14/5/17.
//  Copyright © 2017 MasterBel2. All rights reserved.
//

import Foundation

struct ChangePasswordCommand: ServerCommand {
    var oldPassword: String
    var newPassword: String
    var description: String {
		let p1 = oldPassword.md5()!.base64Encoded() // TODO: -- Error checking
        let p2 = newPassword.md5()!.base64Encoded()
        return "CHANGEPASSWORD \(p1) \(p2)"
    }
}
