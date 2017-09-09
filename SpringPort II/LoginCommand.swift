//
//  LoginCommand.swift
//  OSXSpringLobby
//
//  Created by Belmakor on 30/06/2016.
//  Copyright © 2016 MasterBel2. All rights reserved.
//

import Foundation

struct LoginCommand: ServerCommand {

    let username: String
    let password: String
    var description: String {
        let encodedPassword = password.md5()!.base64Encoded()
        return "LOGIN \(username) \(encodedPassword) 0 * SpringRTSHub 0.01\t0\ta b cl p sp"
    }
}

struct RegisterCommand: ServerCommand {
    
    let username: String
    let password: String
    var description: String {
        let encodedPassword = password.md5()!.base64Encoded()
        return "REGISTER \(username) \(encodedPassword)"
    }
}   
