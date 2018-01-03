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
    
    override var windowNibName: NSNib.Name {
        return NSNib.Name("LoginWindowController")
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
    
    func dismissWithModalResponse(_ response: NSApplication.ModalResponse) {
		guard let window = window else {
			debugPrint("Non-Fatal Error: No Window to dismiss modally.")
			return
		}
		guard let sheetParent = window.sheetParent else {
			fatalError("Fatal Error: window has no sheetParent; cannot dismiss")
		}
        sheetParent.endSheet(window, returnCode: response)
    }

}
