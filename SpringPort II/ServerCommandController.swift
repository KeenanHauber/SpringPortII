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
		let port = 8200 // TODO: -- Add proper handling of port
		
		var serverName = server // Variable so can fix format of "Official Server"
		var serverAddress = serverName
		self.username = username
		self.password = password
		
        if serverName == "Official Server" || serverName == "Official server" || serverName == "official Server" || serverName == "official server" {
			serverAddress = "lobby.springrts.com"
			serverName = "Official Server"
		}
		let server = TASServer(name: serverName, address: serverAddress, port: port)
		
		
		debugPrint("Connecting to \(serverAddress):\(port)")
		server.connect()
		
		delegate?.setTASServer(server)
		
		self.server = server // DON"T COMMENT THIS OUT IT"S USEFUL
		// Why though? I don't know. But it is. Stops it from crashing.
		
		// - - TODO: GIVE THE SERVER ITS DELEGATES
		// Or do you not want to do that?
		// Wait where does this need to happen?
		// Does it happen at delegate?
    }
}
