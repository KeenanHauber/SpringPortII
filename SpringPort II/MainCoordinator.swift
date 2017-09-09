//
//  MainCoordinator.swift
//  SpringPort II
//
//  Created by MasterBel2 on 25/3/17.
//  Copyright © 2017 MasterBel2. All rights reserved.
//

import Cocoa

// The function setUp() is designed to be overwritten. For any individual setup. Cool, huh?
// As in, do not override the init() function. Because it just doesn't work. :D

protocol ServerCommandRouter: class {
    func send(_ serverCommand: ServerCommand)
    func find(user: String) -> User?
    func myUsername() -> String
}

class MainCoordinator: ServerCommandRouter, LoginControllerDelegate, ServerMessageControllerDelegate, UsersDataControllerDelegate, ChannelDataControllerDelegate, BattleListControllerDelegate, BattleroomControllerDelegate, ServerCommandControllerDelegate, ReplayControllerDelegate {
    var username: String?
    var password: String?
    
    var cacheManager: CacheManager?
    
    var connectingToRegister: Bool = false
    
    weak var server: TASServer? // This is stored in the ServerCommandController object. Be careful to not deallocate it.
    
    var springProcessController: SpringProcessController?
    var replayController: ReplayController?
    var singlePlayerController: SinglePlayerController?
    var loginController: LoginController?
    var serverMessageController: ServerMessageController?
    var usersDataController: UsersDataController?
    var channelDataController: ChannelDataController?
    var channelDataSource: ChannelDataSource?
    var battleListController: BattleListController?
    var battleroomController: BattleroomController?
    
    var serverCommandController = ServerCommandController()
    
    // MARK: - Functions to override
    func setUp() { // To be overridden
        // Called by init()
    }
    func loginSetUp() { // To be overridden
        // Called by didSuccessfullyLogIn()
    }
    
    func setUpBattleRoom() { // To be overridden
        // Called by didJoin(_:)
    }
    func leaveBattleRoom() { // To be overridden
        // Called by didLeaveBattle() [this one is okay to stay?]
    }
    
    // MARK: - ServerCommandRouter
    
    func send(_ serverCommand: ServerCommand) {
        server?.send(serverCommand)
    }
    
    func find(user: String) -> User? {
        guard let usersDataController = usersDataController else { return nil }
        return usersDataController.find(user: user)
    }
    func myUsername() -> String {
        return self.username ?? "Not logged in"
    }
    
    // MARK: - LoginControllerDelegate
    
    func connect(to server: String, with username: String, and password: String) {
        self.username = username
        self.password = password
        serverCommandController.connect(to: server, with: username, and: password)// WHY are you palming this off?
    }
    func sendLoginCommand() {
//        let serverName = "Official Server"
        guard let username = username, let password = password else {return}
        if connectingToRegister == false {
            server?.send(LoginCommand(username: username, password: password))
        } else {
            server?.send(RegisterCommand(username: username, password: password))
            connectingToRegister = false
        }
    }
    
    func didSuccessfullyLogIn() {
        guard let channelDataController = channelDataController else { return }
        server?.send(GetIngameTimeCommand())
        channelDataController.requestToJoinChannels()
        loginSetUp()
    }

    // MARK: - ServerMessageControllerDelegate
    func present(_ agreement: String) {
        // MARK: -- To be overridden
    }
    
    // MARK: - UsersDataControllerDelegate
    func userWentIngame(_ username: String) {
        guard let battleroomController = battleroomController else { return }
        if username == battleroomController.battle?.founder {
            let ip = battleroomController.battle?.ip
            let port = battleroomController.battle?.port
            springProcessController?.launchSpring(andConnectTo: ip!, at: port!, with: self.username!/*straight username is the hostname*/, and: self.password!)
        }
    }
    
    func getUsername() -> String {
        return self.username ?? "Not Logged In"
    }

    // MARK: - ChannelDataControllerDelegate
    func requestToJoin(_ channel: String) {
        server?.send(JoinChannelCommand(chanName: channel, password: ""))
    }
    
    // MARK: - BattleListControllerDelegate
    func request(toJoin battle: String, with password: String) {
        let joinBattleCommand = JoinBattleCommand(battleID: battle, password: password, scriptPassword: self.password!)
        server?.send(joinBattleCommand)
    }
    func didJoin(_ battle: Battle) {
        guard let battleroomController = battleroomController else { return }
        battleroomController.didJoin(battle)
        setUpBattleRoom()
    }
    func didLeaveBattle() {
        guard let battleroomController = battleroomController else { return }
        battleroomController.didLeaveBattle()
        leaveBattleRoom()
    }
    
    // MARK: - BattleroomControllerDelegate
    func relaunchSpring() {
        // TODO: -- Check if host is ingame
        guard let battleroomController = battleroomController else { return }
        let ip = battleroomController.battle?.ip
        let port = battleroomController.battle?.port
        
        let springProcessController = SpringProcessController()
        springProcessController.launchSpring(andConnectTo: ip!, at: port!, with: username!, and: password!) // I don't like how this function is presented, but whateves. Plus with all the ! s it's ripe to fail
        self.springProcessController = springProcessController
    }

    // MARK: - ServerCommandControllerDelegate
    func setTASServer(_ server: TASServer) {
        self.server = server
        if let loginController = loginController {
            server.loginDelegates.append(loginController)
        }
        if let serverMessageController = serverMessageController {
            server.messageDelegates.append(serverMessageController)
        }
        if let usersDataController = usersDataController {
            server.usersDelegates.append(usersDataController)
        }
        if let channelDataController = channelDataController {
            server.channelDelegates.append(channelDataController)
        }
        if let battleListController = battleListController {
            server.battleListDelegates.append(battleListController)
        }
        if let battleroomController = battleroomController {
            server.battleDelegates.append(battleroomController)
        }
    }

    // MARK: - ReplayControllerDelegate
    func launch(_ replay: Replay) {
        self.springProcessController = SpringProcessController()
//        springProcessController?.launch(replay)
    }
}
