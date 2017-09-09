//
//  ServerCommandController.swift
//  SpringPort II
//
//  Created by MasterBel2 on 25/3/17.
//  Copyright © 2017 MasterBel2. All rights reserved.
//

import Foundation
protocol ServerCommandControllerDelegate: class {
    func setTASServer(_ server: TASServer)
}

class ServerCommandController {
    var server: TASServer?
    weak var delegate: ServerCommandControllerDelegate?
    var username: String?
    var password: String?
    // Umm… is this object ever set as the delegate?
    func connect(to server: String, with username: String, and password: String) {
        let serverName = server
        if serverName == "Official Server" || serverName == "Official server" || serverName == "official Server" || serverName == "official server" {
            self.server = TASServer(name: "Local Server", address: "lobby.springrts.com", port: 8200)
//            self.server = TASServer(name: "Official Server", address: "lobby.springrts.com", port: 8200)
            self.username = username
            self.password = password
            // - - TODO: GIVE THE SERVER ITS DELEGATES
            // Or do you not want to do that?
            self.server?.connect()
        } else {
            self.server = TASServer(name: "Unknown", address: serverName, port: 8200)
        }
        delegate?.setTASServer(self.server!)
    }
}
