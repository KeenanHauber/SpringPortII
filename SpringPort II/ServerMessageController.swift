//
//  ServerMessageController.swift
//  SpringPort II
//
//  Created by MasterBel2 on 25/3/17.
//  Copyright © 2017 MasterBel2. All rights reserved.
//

import Cocoa

protocol ServerMessageControllerDelegate: ServerCommandRouter { // "class" requirement is implied
    func present(_ message: String)
}

protocol ServerMessageOutput: class {
    func setIngameTime(as time: Int)
}

class ServerMessageController: ServerMessageDelegate {
    var output: ServerMessageOutput?
    weak var delegate: ServerMessageControllerDelegate?
    
    var agreement: [String] = []
    
    var messages: [ServerMessage] = []
    var ingameTimeAsString: String?
    var ingameTime: Int?
    var ingameHours: Int?
    
    // MARK: - ServerMessageDelegate
    
    func server(_ server: TASServer, didReceive message: ServerMessage) {
        messages.append(message)
        let components = message.message.components(separatedBy: " ")
        if components[0] == "Your" && components[1] == "ingame" {
            ingameTimeAsString = components.joined(separator: " ")
            ingameTime = Int(components[4])! // How to not have to force unwrap this?
			guard let ingameTime = Int(components[4]) else { debugPrint("Non-Fatal Error: Failed to parse ingame time message"); return}
            ingameHours = ingameTime/60
            output?.setIngameTime(as: ingameTime)
			self.ingameTime = ingameTime
        }
    }
    
    func server(_ server: TASServer, didRecieve agreementComponent: String) {
        agreement.append(agreementComponent)
    }
    
    func agreementEnd() {
        let agreementText = agreement.joined(separator: "\n")
        delegate?.present(agreementText)
        self.agreement = []
    }
}
