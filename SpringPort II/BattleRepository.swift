//
//  BattleRepository.swift
//  SpringPort II
//
//  Created by MasterBel2 on 25/7/18.
//  Copyright © 2018 MasterBel2. All rights reserved.
//

import Foundation

protocol BattleRepository {
//    func allBattles() -> [Battle]
    func battle(_ id: String) -> Battle?
    func battles(for displayOptions: BattleListDisplayOptions) -> [Battle]
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
    
    func battles(for displayOptions: BattleListDisplayOptions) -> [Battle] {
        var battles = self.battles
        battles.filter { $0.value.engineName == "103.0" || $0.value.engineName == "103" }
        if displayOptions.showEmpty == false { battles.filter { $0.value.playerCount != 0 }}
        
        
        return []
    }
}

