//
//  LobbyServerInfo.swift
//  OSXSpringLobby
//
//  Created by Belmakor on 30/06/2016.
//  Copyright © 2016 MasterBel2. All rights reserved.
//

import Foundation

struct LobbyServerInfo {

    let protocolVersion: String
    let springVersion: String
    let udpPort: String
    let serverMode: String

    init?(messageComponents: [String]) {
        guard messageComponents.count == 5 else { return nil }
        protocolVersion = messageComponents[1]
        springVersion = messageComponents[2]
        udpPort = messageComponents[3]
        serverMode = messageComponents[4] == "0" ? "Normal" : "LAN"
    }
}

extension LobbyServerInfo: CustomStringConvertible {
    var description: String {
        return "Protocol version: \(protocolVersion); Spring version: \(springVersion); UDP port: \(udpPort); Server mode: \(serverMode)"
    }
}
