//
//  BattleListController.swift
//  SpringPort II
//
//  Created by MasterBel2 on 25/3/17.
//  Copyright © 2017 MasterBel2. All rights reserved.
//

import Cocoa

protocol BattleListControllerDelegate: ServerCommandRouter {
    func request(toJoin battle: String, with password: String)
    func didJoin(_ battle: Battle)
    func didLeaveBattle()
}

protocol BattleListDataSource: class {
    func battleCount() -> Int
    func openBattleCount() -> Int
    func battle(for indexPath: IndexPath) -> Battle
    func openBattle(for indexPath: IndexPath) -> Battle
    func founder(for battle: Battle) -> User
    func request(toJoin battle: String, with password: String)
}

protocol BattleListDataOutput: class {
    func reloadBattleListData()
}

class BattleListController: ServerBattleListDelegate, BattleListDataSource {
    weak var delegate: BattleListControllerDelegate!
    var outputs: [BattleListDataOutput] = []
    var battles: [Battle] = []
    
    func server(_ server: TASServer, didOpen battle: Battle) {
        battles.append(battle)
        battleUpdated()
    }
    func server(_ server: TASServer, didCloseBattleWithId battleId: String) {
        battles = battles.filter {$0.battleId != battleId}
        battleUpdated()
    }
    func server(_ server: TASServer, didUpdate battleInfo: UpdatedBattleInfo) {
        let battleId = battleInfo.battleId
        battles
            .filter {$0.battleId == battleId}
            .forEach { battle in
                battle.updateBattle(withInfo: battleInfo)
        }
        battleUpdated()
    }
    func server(_ server: TASServer, userNamed name: String, didJoinBattleWithId battleId: String) {
        battles
            .filter { $0.battleId == battleId }
            .forEach { battle in
                battle.players.append(name)
                battle.updateNumberOfPlayers()
        }
        battleUpdated()
    }
    func server(_ server: TASServer, userNamed name: String, didLeaveBattleWithId battleId: String) { // TODO: - ome of this stuff may beed to be moved over to the Battleroom Controller.
        if name == delegate?.myUsername() {
            delegate?.didLeaveBattle()
        }
        
        battles
            .filter {$0.battleId == battleId}
            .forEach { battle in
                battle.players = battle.players.filter {$0 != name}
                battle.updateNumberOfPlayers()
        }
        battleUpdated()
    }
    func server(_ server: TASServer, didAcceptJoinOf battleID: String, withHash hash: String) {
        
        battles
            .filter { $0.battleId == battleID }
            .forEach { battle in
                delegate?.didJoin(battle) // !!!!
        }
    }
    
    func battleUpdated() {
        battles.sort { $0.playerCount > $1.playerCount }
        for output in outputs {
            output.reloadBattleListData()
        }
    }
    //////////////////////////////////
    // MARK: - BattleListDataSource //
    //////////////////////////////////
    func battleCount() -> Int {
        return battles.count
    }
    
    func battle(for indexPath: IndexPath) -> Battle {
        return battles[indexPath.item]
    }
    func founder(for battle: Battle) -> User {
        let username = battle.founder
        return (delegate?.find(user: username)!)! // Can I stop force unwrapping things?
    }
    
    func request(toJoin battle: String, with password: String) {
        delegate?.request(toJoin: battle, with: password)
    }
    
    // Mark: -- Open Battles Only
    
    // TODO: -- Make these work!
    
    func openBattleCount() -> Int {
        let filteredBattles = battles.filter {$0.playerCount > 0}
        return filteredBattles.count
    }
    
    func openBattle(for indexPath: IndexPath) -> Battle {
        let filteredBattles = battles.filter {$0.playerCount > 0}
        return filteredBattles[indexPath.item]
    }
}
