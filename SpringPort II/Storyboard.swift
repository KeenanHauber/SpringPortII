//
//  Storyboard.swift
//  SpringPort II
//
//  Created by MasterBel2 on 4/8/18.
//  Copyright © 2018 MasterBel2. All rights reserved.
//

import Cocoa

protocol Storyboard {
    func battleListViewController(_ server: TASServer) -> NSViewController
    func loginViewController() -> NSViewController
}

final class DefaultStoryboard: Storyboard {
    
    let window: NSWindow
    
    init(window: NSWindow) {
        self.window = window
    }
    
    func battleListViewController(_ server: TASServer) -> NSViewController {
        let presenter = BattleListPresenter()
        let repository = DefaultBattleRepository()
        let repository2 = DefaultGameRepository()
        
        let interactor = BattleListInteractor(server: server, presenter: presenter, battleRepository: repository, gamesRepository: repository2)
        let viewController = BattlelistViewController(interactor: interactor)
        presenter.display = viewController
        return viewController
    }
    
    func loginViewController() -> NSViewController {
        let presenter = LoginPresenter()
        let router = LoginRouter(storyboard: self)
        let interactor = LoginInteractor(presenter: presenter, router: router)
        let viewController = LoginViewController(interactor: interactor)
        presenter.display = viewController
        router.window = window
        
        return viewController
    }
}
