//
//  LoginController.swift
//  SpringPort II
//
//  Created by MasterBel2 on 25/3/17.
//  Copyright © 2017 MasterBel2. All rights reserved.
//

import Cocoa
protocol LoginControllerDelegate: ServerCommandRouter {
    func sendLoginCommand()
    func connect(to server: String, with username: String, and password: String)
    func didSuccessfullyLogIn()
}

class LoginController: ServerLoginDelegate { // Do you need this when logged in?
//    var loginSheet: LoginWindowController!
    weak var delegate: LoginControllerDelegate!

    
    func server(_ server: TASServer, didLoginUserNamed name: String) {
//        delegate?.send(GetIngameTimeCommand())
        delegate?.didSuccessfullyLogIn()
        //        debugPrint("Succesfully logged in \(name)")
        //        loginViewController.dismiss(self)
        //   mainWindowController.userNameTextField.stringValue = name // Do this somewhere else
//        autoJoinChannels.forEach { channel in
//            server.send(JoinChannelCommand(chanName: channel, password: ""))
//        }
    }
    func server(_ server: TASServer, didConnectToServerWithInfo info: LobbyServerInfo) {
        delegate?.sendLoginCommand() // TODO: - Use connect as soon as UI is up and running again.
    }
    func server(_ server: TASServer, didDenyLoginBecauseOf reason: String) {
        debugPrint(reason)
    }
    
    func server(_ server: TASServer, didDenyRegisterBecauseOf reason: String) {
        debugPrint(reason)
    }
    
    func registrationAccepted() {
        delegate?.sendLoginCommand()
    }
}
