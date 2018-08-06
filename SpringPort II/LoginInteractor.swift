//
//  LoginInteractor.swift
//  TASClient
//
//  Created by MasterBel2 on 17/7/18.
//  Copyright © 2018 MasterBel2. All rights reserved.
//

import Foundation

protocol LoginListening: class {
    func connectedSuccessfully()
    func loginAccepted()
    func loginDenied(_ error: String)
}

protocol LoginInteracting: class {
    func sendLoginRequest(for username: String, and password: String)
    func requestNewAccount()
}

final class LoginInteractor: LoginInteracting {
    let router: LoginRouting
    let presenter: LoginPresenting
    let server: TASServer = {
        let serverName = "Official Server"
        let serverAddress = "lobby.springrts.com"
        let port = 8200
        let server = TASServer(name: serverName, address: serverAddress, port: port)
        return server
    }()
    
    var username: String?
    var password: String?
    
    init(presenter: LoginPresenting, router: LoginRouting) {
        self.presenter = presenter
        self.router = router
    }
    
    func sendLoginRequest(for username: String, and password: String) {
        self.username = username
        self.password = password
        presenter.freezeDisplay()
        server.loginListener = self
        server.connect() // Don't want to send this here, but oh well
    }
    
    func requestNewAccount() {
//        router.routeToRegister()
    }
}

extension LoginInteractor: LoginListening {
    func loginAccepted() {
        router.routeToNext(server: self.server)
    }
    func loginDenied(_ error: String) {
        presenter.resetForNewLoginAttempt(error)
    }
    func connectedSuccessfully() {
        guard let username = username, let password = password else {fatalError("No username or password on connection attempt")}
        server.send(LoginCommand(username: username, password: password))
    }
}
