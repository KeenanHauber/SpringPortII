//
//  BattleRoomDataRepository.swift
//  SpringPort II
//
//  Created by Keenan Hauber on 4/8/18.
//  Copyright © 2018 MasterBel2. All rights reserved.
//

import Foundation

protocol BattleRoomDataRepository {
    var trueSkillTags: [ScriptTag] { get }
    var trueSkillUncertaintyTags: [ScriptTag] { get }
    var gameOptionTags: [ScriptTag] { get }
}

class DefaultBattleRoomDataRepository: BattleRoomDataRepository {
    
    init(id battleID: String) {
        self.battleID = battleID
    }
    
    // Stored Properties
    
    let battleID: String
    var scriptTags: [ScriptTag] = []
    var userBattleStatuses: [String : BattleStatus] = [ : ]
    
    // Computed Properties
    
    var trueSkillTags: [ScriptTag] {
        return scriptTags.filter { tag in tag.table == "skill" }
    }
    
    var trueSkillUncertaintyTags: [ScriptTag] {
        return scriptTags.filter { tag in tag.table == "uncertainty" }
    }
    
    var gameOptionTags: [ScriptTag] {
        return scriptTags.filter { tag in tag.table == "game" }
    }
}

struct ScriptTag {
    var table: String
    var key: String
    var value: String
}
