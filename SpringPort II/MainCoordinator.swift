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

class MainCoordinator: ServerCommandRouter, LoginControllerDelegate, ServerMessageControllerDelegate, UsersDataControllerDelegate, ChannelDataControllerDelegate, BattleListControllerDelegate, BattleroomControllerDelegate, ServerCommandControllerDelegate, ReplayControllerDelegate, SpringProcessControllerDelegate {
    var username: String?
    var password: String?
    
    var connectingToRegister: Bool = false
	var ingame: Bool = false
	
	var cache: Cache?
    weak var server: TASServer? // This is stored in the ServerCommandController object. Be careful to not deallocate it.
	// TODO: -- Fix that
	var springProcess: Process?
	
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
    
    var serverCommandController = ServerCommandController() // Investigate making this an optional
	
	weak var menuDelegate: MenuDelegate!
	
	init(menuDelegate: MenuDelegate) {
		self.menuDelegate = menuDelegate
	}
    
    // MARK: - Functions to override
    func setUp() { // To be overridden
		// Called by declaring object
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
			guard let ip = battleroomController.battle?.ip, let port = battleroomController.battle?.port else {
				debugPrint("Non-Fatal Error: No host address to connect engine to.")
				return
			}
			guard let username = self.username, let password = self.password else {
				debugPrint("Non-Fatal Error: No username or password with which to connect to host. This should never happen.")
				return
			}
			SpringProcessController().launchSpring(andConnectTo: ip, at: port, with: username, and: password) // username is a variable name used twice in this function; please fix?
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
		guard let ip = battleroomController.battle?.ip, let port = battleroomController.battle?.port else {
			debugPrint("Non-Fatal Error: No host address to connect engine to.")
			return
		}
		guard let username = self.username, let password = self.password else {
			debugPrint("Non-Fatal Error: No username or password with which to connect to host. This should never happen.")
			return
		}
        
        let springProcessController = SpringProcessController()
        springProcessController.launchSpring(andConnectTo: ip, at: port, with: username, and: password)
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
//        let springProcessController = SpringProcessController()
//		self.springProcess = springProcessController.launch(<#T##replay: Replay##Replay#>)
    }
	
	// MARK: - SpringProcessControllerDelegate
	
	func springLaunched() {
		menuDelegate.disableSoloGame()
		menuDelegate.disableSpectate()
	}
	
	func springExited() {
		springProcessController = nil
		menuDelegate.enableSoloGame()
		if battleroomController?.battle != nil {
			menuDelegate.enableSpectate()
		}
		server?.send(GetIngameTimeCommand())
	}
}
