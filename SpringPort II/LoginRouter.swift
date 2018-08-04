//
//  LoginRouter.swift
//  TASClient
//
//  Created by Keenan Hauber on 18/7/18.
//  Copyright © 2018 Keenan Hauber. All rights reserved.
//

import Cocoa

protocol LoginRouting {
    func routeToNext(server: TASServer)
    func routeToRegister()
}

final class LoginRouter: LoginRouting {
    weak var window: NSWindow?
    
    weak var sourceViewController: NSViewController?
    
    init(storyboard: Storyboard) {
        self.storyboard = storyboard
    }
    
    let storyboard: Storyboard
    
    func routeToNext(server: TASServer) {
        guard let window = window else {
            debugPrint("Could not route from LoginViewController to BattleListViewController: No window set.")
            return
        }
        window.contentViewController = storyboard.battleListViewController(server)
    }
    
    func routeToRegister() {
        
    }
}
