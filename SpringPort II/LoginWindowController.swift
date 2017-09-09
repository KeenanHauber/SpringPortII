//
//  LoginWindowController.swift
//  SpringPort II
//
//  Created by MasterBel2 on 8/1/17.
//  Copyright © 2017 MasterBel2. All rights reserved.
//

import Cocoa

protocol LoginWindowControllerDelegate: class {
    func connect(toServer serverName: String, withUsername username: String, andPassword password: String)
}

class LoginWindowController: NSWindowController {
    @IBOutlet weak var usernameTextField: NSTextField!
    @IBOutlet weak var passwordTextField: NSTextField!
    @IBOutlet weak var serverTextField: NSTextField!
    
    override var windowNibName: String {
        return "LoginWindowController"
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        // Do view setup here.
    }
    weak var delegate: LoginWindowControllerDelegate?
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        let username = usernameTextField.stringValue
        let password = passwordTextField.stringValue
        var server: String {
            if serverTextField.stringValue == "" {
                return "Official Server"
            } else {
                return serverTextField.stringValue
            }
        }
        
        delegate?.connect(toServer: server, withUsername: username, andPassword: password)
    }
    
    func dismissWithModalResponse(_ response: NSModalResponse) {
        window!.sheetParent!.endSheet(window!, returnCode: response)
    }

}
