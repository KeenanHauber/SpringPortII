//
//  ServerMessageController.swift
//  SpringPort II
//
//  Created by MasterBel2 on 25/3/17.
//  Copyright © 2017 MasterBel2. All rights reserved.
//

import Cocoa

protocol ServerMessageControllerDelegate: class, ServerCommandRouter {
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
            ingameTime = Int(components[4])!
            ingameHours = (ingameTime!)/(60)
            output?.setIngameTime(as: ingameTime!)
//            mainWindowController.ingameTimeTextField.stringValue = "Ingame Time: \(String(ingameTime)) minutes (\(ingameHours) hours)"
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
