//
//  BattleRepository.swift
//  SpringPort II
//
//  Created by Keenan Hauber on 25/7/18.
//  Copyright © 2018 MasterBel2. All rights reserved.
//

import Foundation


protocol BattleListening: class {
    func battleOpened(_ message: String)
    func battleClosed(_ id: String)
    func updateBattleInfo(_ components: [String])
    func joinedBattle(_ components: [String])
    func leftBattle(_ components: [String]) // Used to recognise when blahh
    
    // Battleroom only
    
//    func joinBattle(_ components: [String])
//    func setScriptTags(_ components: [String])
//    func clientBattleStatus(_ components: [String])
//    func requestBattleStatus(_ components: [String])
//    func saidBattle(_ components: [String])
//    func saidBattleEx(_ components: [String])
//    func forceQuitBattle(_ components: [String])
//    func forceJoinBattle(_ components: [String])
}


protocol BattleRepository {
//    func allBattles() -> [Battle]
    func battle(_ id: String) -> Battle?
//    func add(_ battle: Battle)
//    func removeBattle(_ id: Int)
//    func addListeningBlock(_ listeningBlock: ([Battle]) -> ())
}

class DefaultBattleRepository: BattleRepository {
    func battle(_ id: String) -> Battle? {
        return battles[id]
    }
    
    var updateBlocks: [([String : Battle]) -> ()] = []
    
    var idOfJoinedBattle: String?
    
    var battles: [String : Battle] = [ : ] // BattleId, Battle
    
    
    private func updateOutputs() {
        for updateBlock in updateBlocks {
            updateBlock(battles)
        }
    }
}

extension DefaultBattleRepository: BattleListening {
    func battleOpened(_ message: String) {
        guard let battle = Battle(message: message) else { return }
        battles[battle.battleId] = battle
    }
    
    func battleClosed(_ id: String) {
        battles[id] = nil
    }
    
    func updateBattleInfo(_ components: [String]) {
        guard let updatedBattleInfo = UpdatedBattleInfo(components: components) else {
            return
        }
        guard let battle = battles[updatedBattleInfo.battleId] else { return }
        battle.update(for: updatedBattleInfo)
    }
    
    func joinedBattle(_ arguments: [String]) {
        guard arguments[0] == "JOINEDBATTLE" else { return }
        let id = arguments[1]
        let username = arguments[2]
        battles[id]?.players.append(username)
    }
    
    func leftBattle(_ arguments: [String]) {
        guard arguments[0] == "LEFTBATTLE" else { return }
        let id = arguments[1]
        let username = arguments[2]
        guard let battle = battles[id] else { return }
        battle.players = battle.players.filter { $0 != username }
    }
    
    // Battleroom
    
    func joinBattle(_ components: [String]) {
        // JOINBATTLE battleID hashCode
        let id = components[1]
        guard let battle = battles[id] else { return }
        idOfJoinedBattle = id
        
    }
    
    
}
