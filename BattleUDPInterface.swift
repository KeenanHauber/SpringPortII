//
//  BattleUDPInterface.swift
//  SpringPort II
//
//  Created by MasterBel2 on 6/1/17.
//  Copyright © 2017 MasterBel2. All rights reserved.
//

import Cocoa

class BattleUDPInterface: NSObject, SocketDelegate {
    let ip: String
    let port: Int
    let socket: Socket
    init(ip: String, port: String) {
        self.ip = ip
        self.port = Int(port)!
        self.socket = Socket(address: self.ip, port: self.port)
        super.init()
        socket.delegate = self
    }
    @objc func sendPing() {
        socket.send(message: "PING\n")
        perform(#selector(BattleUDPInterface.sendPing), with: nil, afterDelay: 30)
    }
    
    fileprivate func process(message: String) {
        guard !message.isEmpty else { return }
        
        let components = message.components(separatedBy: " ")
        
        // TODO: support optional #id prefix to messages
        guard let commandName = components.first?.uppercased() else { return }
        
        switch commandName {
        default:
            break
        }
    }
    // MARK: - SocketDelegate
    func socket(_ socket: Socket, didReceive message: String) {
        let messages = message.components(separatedBy: "\n")
        for message in messages {
            process(message: message)
        }
    }
}
