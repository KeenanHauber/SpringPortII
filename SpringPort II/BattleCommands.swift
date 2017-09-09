//
//  JoinBattleCommand.swift
//  SpringPort
//
//  Created by MasterBel2 on 24/9/16.
//  Copyright © 2016 MasterBel2. All rights reserved.
//

import Cocoa

struct JoinBattleCommand: ServerCommand {
    let battleID: String
    let password: String
    let scriptPassword: String
    var description: String {
        print("JOINBATTLE \(battleID) \(password) \(scriptPassword)")
        return "JOINBATTLE \(battleID) \(password) \(scriptPassword)"
    }
}

struct LeaveBattleCommand: ServerCommand {
    var description: String {
        return "LEAVEBATTLE"
    }
}

struct MyBattleStatusCommand: ServerCommand {
    var battleStatus: Int = 0
    var isReady: Int = 0
    var teamNumber: Int = 0
    var allyNumber: Int = 0
    var isPlayer: Int = 0
    var handicap: Int = 0
    var syncStatus: Int = 0
    var side: Int = 0
    var color: Int32 = 0
    init(battleStatus: Int) {
        self.battleStatus = battleStatus
    }
    init(battleStatusObject: BattleStatus) {
        if battleStatusObject.isReady == true {
            self.isReady = 1
        } else {
            self.isReady = 0
        }
        self.teamNumber = battleStatusObject.teamNumber
        self.allyNumber = battleStatusObject.allyNumber
        if battleStatusObject.isPlayer == true {
            self.isPlayer = 1
        } else {
            self.isPlayer = 0
        }
        
        switch battleStatusObject.synced {
        case .unknown:
            self.syncStatus = 0
        case .synced:
            self.syncStatus = 1
        case .unsynced:
            self.syncStatus = 2
        }
        
        // Computation
        self.battleStatus += isReady*2 // 2^1
        self.battleStatus += teamNumber*4 // 2^2
        self.battleStatus += allyNumber*64 // 2^6
        self.battleStatus += isPlayer*1024 // 2^10
        self.battleStatus += syncStatus*4194304 // 2^22
        self.battleStatus += side*16777216 // 2^24
    }
    var description: String {
        return "MYBATTLESTATUS \(battleStatus) \(color)"
    }
}

struct SayBattleCommand: ServerCommand {
    let message: String
    var description: String {
        return "SAYBATTLE \(message)"
    }
}

struct SayBattleExCommand: ServerCommand {
    let message: String
    var description: String {
        return "SAYBATTLEEX \(message)"
    }
}
