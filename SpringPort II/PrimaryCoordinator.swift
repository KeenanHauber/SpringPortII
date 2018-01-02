//
//  PrimaryCoordinator.swift
//  SpringPort II
//
//  Created by MasterBel2 on 25/3/17.
//  Copyright © 2017 MasterBel2. All rights reserved.
//

import Cocoa

class PrimaryCoordinator: MainCoordinator, BattleRoomWindowControllerDataSource, BattleRoomWindowControllerDelegate, MainWindowControllerDelegate {
    var mainWindowController: MainWindowController!
    var battleRoomWindowController: BattleRoomWindowController?
    //////////////////////////////////
    // MARK: - Overriding Functions //
    //////////////////////////////////
    
    override func setUp() {
        let loginController = LoginController()
        let serverMessageController = ServerMessageController()
        let usersDataController = UsersDataController()
        let channelDataController = ChannelDataController()
        let battleListController = BattleListController()
        let battleroomController = BattleroomController()
        let serverCommandController = ServerCommandController()
        let singlePlayerController = SinglePlayerController()
        
        
//        let replayController = ReplayController()
//        replayController.replays.append(Replay())
//        replayController.delegate = self
//        self.replayController = replayController
//        launch(Replay())
        
        loginController.delegate = self
        serverMessageController.delegate = self
        usersDataController.delegate = self
        channelDataController.delegate = self
        battleListController.delegate = self
        battleroomController.delegate = self
        serverCommandController.delegate = self
        
        self.singlePlayerController = singlePlayerController
        self.loginController = loginController
        self.serverMessageController = serverMessageController
        self.usersDataController = usersDataController
        self.channelDataController = channelDataController
        self.battleListController = battleListController
        self.battleroomController = battleroomController
        self.serverCommandController = serverCommandController
        
        let mainWindowController = MainWindowController()
        mainWindowController.delegate = self
        mainWindowController.showWindow(self) // Is it okay to have nil here?
        mainWindowController.setUp()
        
        mainWindowController.channelUserListDataController?.dataSource = self.channelDataController
        mainWindowController.totalLoggedInUsersDataController?.dataSource = self.usersDataController
        mainWindowController.openBattleListDataController?.dataSource = self.battleListController
        channelDataController.output = mainWindowController
        usersDataController.output = mainWindowController
        serverMessageController.output = mainWindowController
        battleListController.outputs.append(mainWindowController)
        
        
        
        mainWindowController.presentLoginSheet()

        self.mainWindowController = mainWindowController
    }
    
    override func loginSetUp() {
		guard let username = username else {
			fatalError("Fatal Error: Login requested without username")
		}
		guard let loginWindow = mainWindowController.loginWindow else {
			fatalError("Fatal Error: Login Window cannot be dismissed; does not exist")
		}
		
		mainWindowController.userNameTextField.stringValue = username
        mainWindowController.hideSinglePlayerWarning()
        mainWindowController.window?.endSheet(loginWindow)
		mainWindowController.loginViewController = nil
        mainWindowController.loginWindow = nil
    }
    
    override func setUpBattleRoom() {
        let battleRoomWindowController = BattleRoomWindowController()
        battleRoomWindowController.showWindow(self)
        battleRoomWindowController.setUp()
        battleRoomWindowController.dataSource = self
        battleRoomWindowController.delegate = self
        battleRoomWindowController.playerTableViewDataController.dataSource = battleroomController
        battleRoomWindowController.spectatorTableViewDataController.dataSource = battleroomController
        
        self.battleroomController?.output = battleRoomWindowController
        
        self.battleRoomWindowController = battleRoomWindowController
    }
    
    override func leaveBattleRoom() {
        battleRoomWindowController = nil
        self.battleroomController?.output = nil
    }
    
    override func present(_ agreement: String) {
        let alert = NSAlert()
        alert.messageText = agreement
        alert.addButton(withTitle: "Cancel")
        alert.addButton(withTitle: "Agree")
        let response = alert.runModal()
        
        switch response {
        case NSAlertFirstButtonReturn:
            // TODO: -- Alert or sth
            break
        case NSAlertSecondButtonReturn:
            self.server?.send(ConfirmAgreementCommand())
            self.connectingToRegister = false
            self.sendLoginCommand()
        default:
            break
        }
        super.present(agreement)
        }
    
    //////////////////////////////////////////
    // MARK: - MainWindowControllerDelegate //
    //////////////////////////////////////////
    
    func sendChannelMessage(message: String) {
        guard let chanName = channelDataController?.getSelectedChannel() else {return}
        print(chanName) // TODO: -- IRCStyle messages
        var components = message.components(separatedBy: " ")
        guard let first = components.first else { return }
        switch first {
        case "/me":
            components.remove(at: 0)
            let remainder = components.joined(separator: " ")
        default:
            server?.send(SayCommand(chanName: chanName, message: message))
        }
    }
    
    func selectChannel(atIndex index: Int) {
        channelDataController?.setSelectedChannel(as: index)
    }
    
    func startQuickGame() {
        guard let singlePlayerController = singlePlayerController else { return }
        guard let springProcessController = self.springProcessController else {
            let springProcessController = SpringProcessController()
            springProcessController.launch(singlePlayerController.generateGame())
            self.springProcessController = springProcessController
            mainWindowController.singlePlayerWindow = nil
            return
        }
        springProcessController.launch(singlePlayerController.generateGame())
        // TODO: -- Move this to the MainCoordinator? Or sth.
        mainWindowController.singlePlayerWindow = nil
    }
    
    func closeSinglePlayerWindow() {
        mainWindowController.singlePlayerWindow = nil
    }
    
    func login(to server: String, with username: String, and password: String) {
        connectingToRegister = false
        connect(to: server, with: username, and: password)
    }
    
    func register(on server: String, with username: String, and password: String) {
        connectingToRegister = true
        connect(to: server, with: username, and: password)
    }
    
    //////////////////////////////////////////////////
    // MARK: - BattleRoomWindowControllerDataSource //
    //////////////////////////////////////////////////
    
    func myBattleNATType() -> NATType {
        return (battleroomController?.battle?.natType) ?? .none
    }
    
    func myBattleStatus() -> BattleStatus {
        let client = (usersDataController?.users.filter {$0.username == self.username })?[0]
        return client?.battleStatus ?? BattleStatus("0", withColor: "0")
    }
    
    ////////////////////////////////////////////////
    // MARK: - BattleRoomWindowControllerDelegate //
    ////////////////////////////////////////////////
	
	func promoteBattle() {
		guard let battle = battleroomController?.battle else { debugPrint("Non-Fatal Error: Cannot promote battle; no battle set."); return }
		server?.send(PromoteCommand(battleId: battle.battleId))
	}
	
    func send(_ battleMessage: String) {
        server?.send(SayBattleCommand(message: battleMessage)) // TODO: -- IRCStyle messages (/me)
    }
    
    func leaveBattle() {
        server?.send(LeaveBattleCommand())
    }
    
    func updateClientBattleStatus(to option: BattleStatusOption) {
        guard let client = (usersDataController?.users.filter {$0.username == self.username })?[0] else {
			debugPrint("Non-Fatal Error: Cannot find ")
			return
		}
		
		guard let battleStatus = client.battleStatus else {
			debugPrint("Non-Fatal Error: No battleStatus for client (self), cannot update battlestatus")
			return
		}
		switch option { // NOTE: -- Battlestatus is a class; therefore it affects the users' stored battlestatus. Should I update appropriately? Or should I set it to a struct? [probably wise actually] 
        case .Spectator:
            battleStatus.isPlayer = false
            server?.send(MyBattleStatusCommand(battleStatusObject: battleStatus))
        case .Player:
            battleStatus.isPlayer = true
            server?.send(MyBattleStatusCommand(battleStatusObject: battleStatus))
        case .Ready:
            battleStatus.isReady = true
            server?.send(MyBattleStatusCommand(battleStatusObject: battleStatus))
        case .Unready:
            battleStatus.isReady = false
            server?.send(MyBattleStatusCommand(battleStatusObject: battleStatus))
        }
    }
}
