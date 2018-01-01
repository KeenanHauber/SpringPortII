//
//  LoginViewController.swift
//  SpringPort II
//
//  Created by MasterBel2 on 31/3/17.
//  Copyright © 2017 MasterBel2. All rights reserved.
//

import Cocoa

protocol LoginViewControllerDelegate: class {
    func loginRequested(for username: String, with password: String, to server: String)
    func registerRequested(for username: String, with password: String, to server: String)
}

class LoginViewController: NSViewController {
    @IBOutlet weak var usernameTextField: NSTextField!
    @IBOutlet weak var passwordTextField: NSTextField!
    @IBOutlet weak var serverTextField: NSTextField!
    weak var delegate: LoginViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func attemptLogin(_ sender: Any) {
        let username = usernameTextField.stringValue
        let password = passwordTextField.stringValue
        let server = serverTextField.stringValue
        delegate?.loginRequested(for: username, with: password, to: server)
    }
    @IBAction func attemptRegister(_ sender: Any) {
        let username = usernameTextField.stringValue
        let password = passwordTextField.stringValue
        let server = serverTextField.stringValue
        delegate?.registerRequested(for: username, with: password, to: server)
    }
    
}
