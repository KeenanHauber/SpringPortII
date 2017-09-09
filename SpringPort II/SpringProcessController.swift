//
//  SpringProcessController.swift
//  SpringPort II
//
//  Created by MasterBel2 on 25/3/17.
//  Copyright © 2017 MasterBel2. All rights reserved.
//

import Cocoa

class SpringProcessController {
    var springProcess: Process?
    var username: String?
    var password: String?
    
    func launchSpring(andConnectTo ip: String, at port: String, with username: String, and password: String) {
        self.username = username
        self.password = password
        let scriptTxtManager = ScriptTxtManager(ip: ip, port: port, username: self.username!, scriptPassword: self.password!)
        scriptTxtManager.delegate = self
        scriptTxtManager.prepareForLaunchOfSpringAsClient()
        startSpringRTS()
    }
    
    func forceLaunchSpring(andConnectTo ip: String, at port: String, with scriptPassword: String, and username: String) {
        self.username = username
        let scriptTxtManager = ScriptTxtManager(ip: ip, port: port, username: self.username!, scriptPassword: scriptPassword)
        scriptTxtManager.delegate = self
        scriptTxtManager.prepareForLaunchOfSpringAsClient()
        startSpringRTS()
    }
    
    func startSpringRTS() {
        let path = NSWorkspace.shared().fullPath(forApplication: "Spring_103.0.app")
        let bundle = Bundle(path: path!)!
        
        //        let scriptFileName = "script.txt"
        let process = Process()
        process.launchPath = bundle.executablePath
        process.arguments = ["\(NSHomeDirectory())/.spring/script.txt"]
        process.terminationHandler = { _ in
            print("Spring engine exited")
            self.springProcess = nil
        }
        springProcess = process
        process.launch()
    }
    
    func launch(_ replay: Replay) {
        let scriptTxtManager = ScriptTxtManager(replay)
        scriptTxtManager.delegate = self
        scriptTxtManager.prepareForLaunchOfReplay()
        startSpringRTS()
    }
    
    func launch(_ game: SinglePlayerGame) {
        let scriptTxtManager = ScriptTxtManager(game)
        scriptTxtManager.delegate = self
        scriptTxtManager.prepareForLaunchOfSinglePlayerGame()
        startSpringRTS()
    }
}

extension SpringProcessController: ScriptTxtManagerDelegate {
    // MARK: - ADelegate
    func present(error errorMessage: String) {
        let alert = NSAlert()
        alert.messageText = errorMessage
        alert.addButton(withTitle: "Ok")
        //let window = mainWindowController.window!// I want this as a popup, independant of the MWC. Please.
        //alert.beginSheetModal(for: window, completionHandler: { (response) -> Void in
        //})
    }
}

extension SpringProcessController: ServerSomethingDelegate {
    func server(_ server: TASServer, instructedToConnectTo ipAndPort: String, with scriptPassword: String) {
        let anArray = ipAndPort.components(separatedBy: ":")
        let username = "MasterBel2" // TODO: - Do something about this, get the actual value for somewhere. Currently stored int the ServerCommandController :(
        forceLaunchSpring(andConnectTo: anArray[0], at: anArray[1], with: scriptPassword, and: username)
    }
}
