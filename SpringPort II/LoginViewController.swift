//
//  LoginViewController.swift
//  TASClient
//
//  Created by Keenan Hauber on 17/7/18.
//  Copyright © 2018 Keenan Hauber. All rights reserved.
//

import Cocoa

class LoginViewController: NSViewController {
    @IBOutlet weak var backgroundImageView: NSImageView!
    @IBOutlet weak var usernameField: NSTextField!
    @IBOutlet weak var passwordField: NSSecureTextField!
    @IBOutlet weak var loginButton: NSButton!
    
    let interactor: LoginInteracting
    
    convenience init() { // ichhhhhhh
        let server: TASServer = {
            let serverName = "Official Server"
            let serverAddress = "lobby.springrts.com"
            let port = 8200
            let server = TASServer(name: serverName, address: serverAddress, port: port)
            return server
        }()
        
        let presenter = LoginPresenter()
//        let router = RegisterRouter()
        let defaultInteractor = LoginInteractor(presenter: presenter, server: server/*, router: router*/)
        self.init(interactor: defaultInteractor)
        presenter.display = self
//        router.sourceViewController = self
    }
    
    required init(interactor: LoginInteracting) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func requestLogin(_ sender: Any) {
        let username = usernameField.stringValue
        let password = passwordField.stringValue
        interactor.sendLoginRequest(for: username, and: password)
    }
    
    @IBAction func requestNewAccount(_ sender: Any) {
        interactor.requestNewAccount()
    }
}

extension LoginViewController: LoginDisplay {
    func freeze() {
        usernameField.isEditable = false
        passwordField.isEditable = false
        loginButton.isEnabled = false
    }
    
    func unfreeze() {
        usernameField.isEditable = true
        passwordField.isEditable = true
        loginButton.isEnabled = true
    }
    
    func display(_ errorString: String) {
        // TODO
    }
    
    func clearPassword() {
        passwordField.stringValue = ""
    }
    
    func clearUsername() {
        usernameField.stringValue = ""
    }
}
