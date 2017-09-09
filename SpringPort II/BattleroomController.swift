//
//  BattleroomController.swift
//  SpringPort II
//
//  Created by MasterBel2 on 25/3/17.
//  Copyright © 2017 MasterBel2. All rights reserved.
//

import Cocoa

protocol BattleroomControllerDelegate: ServerCommandRouter {
    func find(user: String) -> User?
    func relaunchSpring()
}

protocol BattleRoomDataSource: class {
    func numberOfPlayersInCurrentBattle() -> Int
    func player(at row: Int) -> User
    
    func trueSkillDictionary() -> [String : String]
    
    func numberOfSpectatorsInCurrentBattle() -> Int
    func spectator(at row: Int) -> User
}

protocol BattleRoomDataOutput: class {
    func updateSpectators()
    func updatePlayers()
    func updateBattleStatus()
    func newChatLog(_ log: NSAttributedString)
}

class BattleroomController: ServerBattleDelegate {
    weak var delegate: BattleroomControllerDelegate?
    weak var output: BattleRoomDataOutput?
    
    var battle: Battle?
    var battleMessages: [Message] = []
    
    func relaunchSpring() {
        guard let battle = self.battle else { return }
        if battle.natType == .none {
            if let host = delegate?.find(user: battle.founder) {
                if host.status.isInGame == true {
                    // Um… what was here?
                    delegate?.relaunchSpring()
                }
            }
        }
    }
    
    func setBattleChatLog() {
        let log = NSMutableAttributedString()
        for message in battleMessages {
            switch message.style {
            case "Standard":
                let messageAsString = "(\(message.timeStamp))(\(message.sender))(-> \(message.message) \n"
                let messageAsNSAttributedString = NSAttributedString(string: messageAsString, attributes: [NSForegroundColorAttributeName : NSColor.orange] )
                log.append(messageAsNSAttributedString)
                
            case "IRCStyle":
                let messageAsString = "(\(message.timeStamp))(-> \(message.sender) \(message.message)\n"
                let messageAsNSAttributedString = NSAttributedString(string: messageAsString, attributes: [NSForegroundColorAttributeName : NSColor.magenta] )
                log.append(messageAsNSAttributedString)
            case "Server":
                let messageAsString = "(\(message.timeStamp))( ### \(message.sender) ### )(-> \(message.message) ###)\n"
                let messageAsNSAttributedString = NSAttributedString(string: messageAsString, attributes: [NSForegroundColorAttributeName : NSColor.blue] )
                log.append(messageAsNSAttributedString)
            default:
                break
            }
            
        }
        
        output?.newChatLog(log)
    }
    
    func didJoin(_ battle: Battle) {
        self.battle = battle
        setBattleChatLog()
        
        output?.updateSpectators()
        output?.updatePlayers()
        output?.updateBattleStatus()
    }
    func didLeaveBattle() {
        battle = nil
        battleMessages = []
    }
    
    //MARK: - ServerBattleDelegate
    func server(_ server: TASServer, didReceiveScriptTagsAs message: String) {
        battle?.process(scriptTags: message)
        
        output?.updateSpectators()
        output?.updatePlayers()
    }
    
    func server(_ server: TASServer, recievedFromBattle message: String, from sender: String, ofStyle style: String) {
        battleMessages.append(Message(timeStamp: Date(), sender: sender, message: message, style: style))
        setBattleChatLog()
    }
    
    func server(_ server: TASServer, didSetBattleStatus battleStatus: BattleStatus, forUserNamed username: String) {
        output?.updateSpectators()
        output?.updatePlayers()
        output?.updateBattleStatus()
    }
    
    func server(_ server: TASServer, userNamed name: String, didJoinBattleWithId battleId: String) {
        if battleId == battle?.battleId {
            battleMessages.append(Message(timeStamp: Date(), sender: "Server", message: "\(name) joined the battle", style: "Server"))
        }
        setBattleChatLog()
    }
    
    func server(_ server: TASServer, userNamed name: String, didLeaveBattleWithId battleId: String) {
        if battleId == battle?.battleId {
            battleMessages.append(Message(timeStamp: Date(), sender: "Server", message: "\(name) left the battle", style: "Server"))
        }
        setBattleChatLog()
    }
    
    func serverDidRequestBattleStatus() {
        var battleStatus: Int = 0 //TODO: - Set this up better.
        let isReady = 0
        let teamNumber = 1
        let allyNumber = 1
        let isPlayer = 1
        let handicap = 0
        let syncStatus = 1
        let side = 1
        //        let color = 0
        
        battleStatus += isReady*2 // 2^1
        battleStatus += teamNumber*4 // 2^2
        battleStatus += allyNumber*64 // 2^6
        battleStatus += isPlayer*1024 // 2^10
        battleStatus += syncStatus*4194304 // 2^22
        battleStatus += side*16777216 // 2^24
        delegate?.send(MyBattleStatusCommand(battleStatusObject: BattleStatus(String(battleStatus), withColor: "0")))
    }
    func registerBattleKick() {
        let alert = NSAlert()
        alert.messageText = "You were kicked from battle"
        alert.addButton(withTitle: "Ok")
//        let window = mainWindowController.window!
        //        alert.beginSheetModal(for: window, completionHandler: { (response) -> Void in
        //        })
    }
    
}

extension BattleroomController: BattleRoomDataSource { // I am so trusting with the force unwraps. Yay. But whatever.
    func numberOfPlayersInCurrentBattle() -> Int {
        return (battle?.playerCount)!
    }
    
    func numberOfSpectatorsInCurrentBattle() -> Int {
        return (battle?.spectatorCount)!
    }
    
    func player(at row: Int) -> User {
        var players: [User] = []
        for username in (battle?.players)! {
            players.append((delegate?.find(user: username)!)!)
        }
        players.sort {$0.username < $1.username}
        players.sort {($0.battleStatus?.allyNumber ?? 0) < ($1.battleStatus?.allyNumber ?? 1)}
        battle?.updateNumberOfPlayers() // ?? Waht why is this here?
        players = players.filter { $0.battleStatus?.isPlayer == true }
        if row < players.count {
            return players[row]
        } else {
            return User()
        }

    }
    
    func spectator(at row: Int) -> User {
        var spectators: [User] = []
        for username in (battle?.players)! {
            spectators.append((delegate?.find(user: username)!)!)
        }
        spectators.sort {$0.username < $1.username}
        battle?.updateNumberOfPlayers()
        spectators = spectators.filter { $0.battleStatus?.isPlayer == false }
        if row < spectators.count {
            return spectators[row]
        } else {
            return User()
        }
    }
    
    func trueSkillDictionary() -> [String : String] {
        return (battle?.trueSkillDictionary)!
    }
}
