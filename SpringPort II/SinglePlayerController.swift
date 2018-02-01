//
//  SinglePlayerController.swift
//  SpringPort II
//
//  Created by MasterBel2 on 28/3/17.
//  Copyright © 2017 MasterBel2. All rights reserved.
//

import Foundation

protocol SinglePlayerDelegate: class {
    func username() -> String
    func launch(_ game: SinglePlayerGame)
}

//enum Side {
//    case Arm
//    case Core
//    case TLL
//
//    //More to come ??? Or as a string?
//}

struct Scenario {
    let mapName: String
    let startPosType: String // Make this its own object? Enum?
    let numberOfAIs: Int
    let AIShortName: String
    let startPosX: Int?
    let startPosY: Int?
}

struct MO {
    let name: String
    var value: String
    init(_ name: String, _ value: String) {
        self.name = name
        self.value = value
    }
}
struct Team {
    // [TEAM0] {
    let teamLeader: Int // Player number of the leader
    let allyTeamNumber: Int
    let rgbColor: String // r g b in range 0 to 1
    let side: String // Arm/Core; other sides possible with mods other than BA
    let handicap = "0" // Deprecated, see advantage; but is -100 to 100 - % resource income bonus
    
    let advantage: Int // Advantage factor (meta value). Currently only affects incomeMultiplier (below). Valid: [-1.0, FLOAT_MAX]
    let incomeMultiplier: Int // multiplication factor for collected resources. valid [0.0, FLOAT_MAX]
    let startPosX: Int // Use these in combination with StartPosType = 3
    let startPosZ: Int // Range is in map coordinates as returned by UnitSync
    let LuaAI: String = "" // name of the LuaAI that controls this team
    // Either a [PLAYER] or an [AI] is controlling this team, or a LuaAI is set
    // }
}

struct AllyTeam {
    let numAllies: String = "0" // idk
    let allies: [String] = [""] // means that this team is allied with the other, not necesarily the reverse (just put each allied allyteam in the array and you can cycle through them, ok?)
    let startRectTop: String   // Use these in combination with StartPosType=2
    let startRectLeft: String   //   (ie. select in map)
    let startRectBottom: String // range is 0-1: 0 is left or top edge,
    let startRectRight: String  //   1 is right or bottom edge
}

struct SinglePlayerGame {
    
    
    
    // [GAME] {
    let mapName: String // Name of the file
    let gameType: String // either primary mod NAME, rapid tag name or archive name
    let gameStartDelay: Int // optional, in seconds, (unsigned int), default: 4
    let startPosType: String // 0 fixed, 1 random, 2 choose in game, 3 choose before game (see StartPosX)

    let doRecordDemo: Bool // when finally input, 0 for false and 1 for true
    let hostIp: String = "" // Not set for single player, because you ARE the host ;)
    let hostPort: String = "8452" // Not sure why this has to be set but whatever (optional, so doesn't :D)
    let myPlayerName: String // Must be the username set for [PLAYER0]
    let isHost: Bool = true // 1 for true, 0 for false
    
    // [PLAYER0] {
    let username: String
    let password: String // Doesn't really matter: this is single player
    let isSpectator: Bool // 1 for true, 0 for false
    let team: Int // The team number controlled by the player
    let isFromDemo = false // False. This is a single player GAME
    let countryCode = "AU" // Country code of the player. Not necessary.
    let rank = "-1" // Why is this -1 on the example? Ugh, whatever.
    // }
    
    // [AI0] {…} [AIX] {
    let names: [String] // Purely optional. (but used to determine # of AIs) Best to NOT include what type of AI it is :D
    let shortName: String // shortName of the Skirmish AI library or name of the LUA AI that controlls this team see spring.exe --list-skirmish-ais for possible values
    let version: String
    // let teamNumber 
    let hostNumber = "0" // Player number of the computer the ais run on. 0 because it's player 0
    // [OPTIONS] {
    let difficultyLevel = "0" // Not sure the possible values. This needs to be assigned for each AI
    // }}
    
    let teams: [Team]
    
    let allyTeams: [AllyTeam]
    
    // TODO: -- Restrictions
    
    var modOptions: [MO]
    
}



class SinglePlayerController {
    // TODO: - Implement a rating system, so that the players are presented with games that aren't far too hard for them
    var game: SinglePlayerGame?
    weak var delegate: SinglePlayerDelegate?
	weak var cache: Cache?
    
    func generateGame() -> SinglePlayerGame? {
		guard let scenario = generateScenario() else { return nil }
        let gameType = "Balanced Annihilation V9.46"
        let gameStartDelay = 4
        
        // My Player Info
        var username: String {
            guard let username = delegate?.username() else { return "Commander" }
            return username
        }
        let password = ""
        let isSpectator = false
        let team = 0
        
        let names = ["DEFCON_5"]
        let shortName = "ShardLua"
        let version = "<not-versioned>"
        
        var teams: [Team] = []
        teams.append(Team(teamLeader: 0, allyTeamNumber: 0, rgbColor: "0 0 1", side: "Arm", advantage: 0, incomeMultiplier: 1, startPosX: 0, startPosZ: 0))
        for index in 0..<names.count {
            teams.append(Team(teamLeader: 0, allyTeamNumber: 1, rgbColor: "1 0 0", side: "Core", advantage: 0, incomeMultiplier: 1, startPosX: 0, startPosZ: 0))
        }
        
        
        var allyTeams: [AllyTeam] = []
//        allyTeams.append(AllyTeam(startRectTop: 0, startRectBottom: 0, startRect))
        
        var modOptions = [MO("StartMetal", "1000"), // I think these are BA options, but might be universal. Check that.
            MO("StartEnergy", "1000"),
            MO("Max Units", "8765"), // Per Team
            MO("GameMode", "1"), // 0 cmdr dead->game continues, 1 cmdr dead->game ends, 2 lineage, 3 openend
            MO("LimitDGun", "0"), // Dgun radius around start pos
            MO("DisableMapDamage", "0"), // Disable craters?
            MO("GhostedBuildings", "1"), // ghost enemy buildings after losing los on them
            MO("NoHelperAIs", "0"),
            MO("LuaGaia", "1"),
            MO("LuaRules", "1"),
            MO("FixedAllies", "1"),
            MO("MaxSpeed", "3"),
            MO("MinSpeed", "0.3")]
        
        let game = SinglePlayerGame(mapName: scenario.mapName,
                                    gameType: gameType,
                                    gameStartDelay: gameStartDelay,
                                    startPosType: scenario.startPosType,
                                    doRecordDemo: true,
                                    myPlayerName: username,
                                    username: username,
                                    password: password,
                                    isSpectator: isSpectator,
                                    team: team,
                                    names: names,
                                    shortName: shortName,
                                    version: version,
                                    teams: teams,
                                    allyTeams: allyTeams,
                                    modOptions: modOptions)
        
        return game
    }
    
    private func generateScenario() -> Scenario? {
		guard let maps = cache?.mapNames else { return nil }
        let int = Int(arc4random_uniform(UInt32(maps.count-1))) // LEL
		let map = maps[int]
		let scenario = Scenario(mapName: map, startPosType: "0", numberOfAIs: 1, AIShortName: "ShardLua", startPosX: nil, startPosY: nil)
		
		
        return scenario
    }
}

