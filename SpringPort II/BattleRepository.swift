//
//  BattleRepository.swift
//  SpringPort II
//
//  Created by Keenan Hauber on 25/7/18.
//  Copyright © 2018 MasterBel2. All rights reserved.
//

import Foundation


protocol BattleListening: class {
    func battleOpened(_ arguments: String)
    func battleClosed(_ arguments: String)
    func updateBattleInfo(_ arguments: String)
    func joinedBattle(_ arguments: String)
    func leftBattle(_ arguments: String) // Used to recognise when blahh
    
    // Battleroom only
    
    func joinBattle(_ arguments: String)
    func setScriptTags(_ arguments: String)
    func clientBattleStatus(_ arguments: String)
    func requestBattleStatus(_ arguments: String)
    func saidBattle(_ arguments: String)
    func saidBattleEx(_ arguments: String)
    func forceQuitBattle(_ arguments: String)
    func forceJoinBattle(_ arguments: String)
}


protocol BattleRepository {
    func allBattles() -> [Battle]
    func battle(at index: Int) -> Battle
    func add(_ battle: Battle)
    func removeBattle(_ id: Int)
    func set(_ sorting: Sorting)
    func addListeningBlock(_ listeningBlock: ([Battle]) -> ())
}

enum Sorting {
    case AlphabeticalAscending
    case AlphabeticalDescending
    case NumericalAscending
    case NumericalDescending
}

class DefaultBattleRepository: BattleRepository {
    var sorting: Sorting = .NumericalDescending
    var updateBlocks: [(Battle) -> ()]
    
    var battles: [String : Battle] = [ : ] // BattleId, Battle
    
}

extension DefaultBattleRepository: BattleListening {
    
}
