//
//  BattleInfo.swift
//  OSXSpringLobby
//
//  Created by Belmakor on 1/07/2016.
//  Copyright © 2016 MasterBel2. All rights reserved.
//

import Foundation

enum NATType {
    case none
    case holePunching
    case fixedSourcePorts
}

class Battle: NSObject {

    enum BattleType {
        case normal
        case replay
    }

    
    
    var players: [String] = []
    var playerCount: Int = 0
    var spectatorCount: Int = 0
    var isLocked: Bool = false
    var trueSkillDictionary: [String : String] = [:]
    var modOptionDictionary: [String : String] = [:]

    let battleId: String
    let type: BattleType
    let natType: NATType
    let host: String
    let ip: String
    let port: String
    var maxPlayers: Int
    let passworded: Bool
    let rank: String
    var mapHash: Int32
    let engineName: String
    let engineVersion: String
    var mapName: String
    let title: String
    let gameName: String

    init?(message: String) {
        let sentences = message.components(separatedBy: "\t")
        guard sentences.count == 5 else { return nil }

        let first = sentences[0]
        let parts = first.components(separatedBy: " ")
        guard parts.count == 12 else { return nil }

        battleId = parts[1]

        switch parts[2] {
        case "0": type = .normal
        case "1": type = .replay
        default: fatalError("Unsupported battle type: \(parts[1])")
        }

        switch parts[3] {
        case "0": natType = .none
        case "1": natType = .holePunching
        case "2": natType = .fixedSourcePorts
        default: fatalError("Unsupported nat type: \(parts[2])")
        }
        // Establish which user entity is the host
        host = parts[4]
        ip = parts[5]
        port = parts[6]
        maxPlayers = Int(parts[7]) ?? 0
        passworded = parts[8] != "0"
        rank = parts[9]
        mapHash = Int32(parts[10]) ?? 0
        engineName = parts[11]

        engineVersion = sentences[1]
        mapName = sentences[2]
        title = sentences[3]
        gameName = sentences[4]
        
        players.append(host)
        playerCount = players.count - spectatorCount
    }
    
    func updateNumberOfPlayers() {
        playerCount = players.count - spectatorCount
    }
    
    func updateBattle(withInfo battleInfo: UpdatedBattleInfo) {
        self.spectatorCount = battleInfo.spectatorCount
        self.isLocked = battleInfo.isLocked
        self.mapHash = battleInfo.mapHash
        self.mapName = battleInfo.mapName
        updateNumberOfPlayers()
    }
    
    func process(scriptTags scriptTagsAsMessage: String) {
        let messageAsArrayOfScriptTags = scriptTagsAsMessage.components(separatedBy: "\t")
        for scriptTag in messageAsArrayOfScriptTags {
            let scriptTagAsArray = scriptTag.components(separatedBy: "/")
            switch scriptTagAsArray[1] {
            case "players":
                let playerName = scriptTagAsArray[2]
                let trueSkill = scriptTagAsArray[3].components(separatedBy: "=")
                if trueSkill[0] == "skill" {
                    trueSkillDictionary["\(playerName.lowercased())"] = "\(trueSkill[1])"
                } else { // trueSkill[1] == "skilluncertainty"
                    break // TODO
                }
                
            case "modoptions":
                let modOptionCombined = scriptTagAsArray[2].components(separatedBy: "=")
                modOptionDictionary["\(modOptionCombined[0])"] = "\(modOptionCombined[1])"
                
            default:
                break
            }
        }
    }
}
