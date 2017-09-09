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
        mainWindowController.userNameTextField.stringValue = username!
        mainWindowController.hideSinglePlayerWarning()
        mainWindowController.window?.endSheet(mainWindowController.loginWindow!)
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
        guard let loginWindow = mainWindowController.loginWindow else { return }
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
        server?.send(SayCommand(chanName: chanName, message: message))
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
        return (battleroomController?.battle!.natType) ?? .none
    }
    
    func myBattleStatus() -> BattleStatus {
        let client = (usersDataController?.users.filter {$0.username == self.username })?[0]
        return client?.battleStatus ?? BattleStatus("0", withColor: "0")
    }
    
    ////////////////////////////////////////////////
    // MARK: - BattleRoomWindowControllerDelegate //
    ////////////////////////////////////////////////
    
    func send(_ battleMessage: String) {
        server?.send(SayBattleCommand(message: battleMessage)) // TODO: -- IRCStyle messages (/me)
    }
    
    func leaveBattle() {
        server?.send(LeaveBattleCommand())
    }
    
    func updateClientBattleStatus(to option: BattleStatusOption) {
        guard let client = (usersDataController?.users.filter {$0.username == self.username })?[0] else {return}
        switch option {
        case .Spectator:
            client.battleStatus!.isPlayer = false
            server?.send(MyBattleStatusCommand(battleStatusObject: client.battleStatus!))
        case .Player:
            client.battleStatus!.isPlayer = true
            server?.send(MyBattleStatusCommand(battleStatusObject: client.battleStatus!))
        case .Ready:
            client.battleStatus!.isReady = true
            server?.send(MyBattleStatusCommand(battleStatusObject: client.battleStatus!))
        case .Unready:
            client.battleStatus!.isReady = false
            server?.send(MyBattleStatusCommand(battleStatusObject: client.battleStatus!))
        }
    }
}
