//
//  SpringProcessController.swift
//  SpringPort II
//
//  Created by MasterBel2 on 25/3/17.
//  Copyright © 2017 MasterBel2. All rights reserved.
//

import Cocoa

protocol SpringProcessControllerDelegate: class {
	func springLaunched()
	func springExited()
}

class SpringProcessController {
    var springProcess: Process?
	weak var delegate: SpringProcessControllerDelegate!
    
    func launchSpring(andConnectTo ip: String, at port: String, with username: String, and password: String) {
        let scriptTxtManager = ScriptTxtManager(ip: ip, port: port, username: username, scriptPassword: password)
        scriptTxtManager.delegate = self
        scriptTxtManager.prepareForLaunchOfSpringAsClient()
        startSpringRTS()
    }
    
    func forceLaunchSpring(andConnectTo ip: String, at port: String, with scriptPassword: String, and username: String) {
        let scriptTxtManager = ScriptTxtManager(ip: ip, port: port, username: username, scriptPassword: scriptPassword)
        scriptTxtManager.delegate = self
        scriptTxtManager.prepareForLaunchOfSpringAsClient()
        startSpringRTS()
    }
    
    func startSpringRTS() {
		// TODO: --Some sort of cache interface to allow multiple engines to be used
        guard let path = NSWorkspace.shared.fullPath(forApplication: "Spring_103.0.app") else { debugPrint("Non-Fatal Error: could not find Spring_103.0.app"); return }
		guard let bundle = Bundle(path: path) else { debugPrint("Non-Fatal Error: could not create bundle object for SpringRTS"); return }
        
        let scriptFileName = "script.txt"
        let process = Process()
        process.launchPath = bundle.executablePath
        process.arguments = ["\(NSHomeDirectory())/.spring/\(scriptFileName)"]
        process.terminationHandler = { _ in
            debugPrint("Spring engine exited")
            self.springProcess = nil
			self.delegate?.springExited()
        }
		process.launch()
        springProcess = process
		delegate?.springLaunched()
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
    func present(error errorMessage: String) {
        let alert = NSAlert()
        alert.messageText = errorMessage
        alert.addButton(withTitle: "Ok")
    }
}

extension SpringProcessController: ServerSomethingDelegate {
    func server(_ server: TASServer, instructedToConnectTo ipAndPort: String, with scriptPassword: String) {
        let anArray = ipAndPort.components(separatedBy: ":")
        let username = "MasterBel2" // TODO: -- Do something about this, get the actual value for somewhere. Currently stored int the ServerCommandController :(
        forceLaunchSpring(andConnectTo: anArray[0], at: anArray[1], with: scriptPassword, and: username)
    }
}
