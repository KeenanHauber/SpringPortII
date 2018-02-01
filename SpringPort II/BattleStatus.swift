//
//  BattleStatus.swift
//  SpringPort II
//
//  Created by MasterBel2 on 3/1/17.
//  Copyright © 2017 MasterBel2. All rights reserved.
//

import Cocoa

class BattleStatus: NSObject { // Why is this a class?
    enum SyncStatus: Int {
        case unknown = 0
        case synced = 1
        case unsynced = 2
    }
    var isReady: Bool
    var teamNumber: Int
    var allyNumber: Int
    var isPlayer: Bool
    var handicap: Int // At this point in time I know not what to do with this
    var synced: SyncStatus
    var side: Int 
    var trueSkill: Int = 20
    var skillUncertainty: Int = 0
    
    var color: NSColor
    
    init(_ battleStatus: String, withColor color: String) {
        // BattleStatus First
//        print("BattleStatus:")
//        print(battleStatus)
        let statusValue = Int(battleStatus) ?? 0
//        print("StatusValue:")
//        print(statusValue)
        self.isReady = (statusValue & 0b10) == 0b10
        self.teamNumber = (statusValue & 0b111100) >> 2 
        self.allyNumber = (statusValue & 0b1111000000) >> 6
        self.isPlayer = (statusValue & 0b10000000000) == 0b10000000000
        self.handicap = (statusValue & 0b111111100000000000) >> 11
        let syncStatus = (statusValue & 0b110000000000000000000000) >> 22
        switch syncStatus {
        case 0:
            self.synced = .unknown
        case 1:
            self.synced = .synced
        case 2:
            self.synced = .unsynced
        default:
            self.synced = .unknown
        }
        self.side = (statusValue & 0b1111000000000000000000000000) >> 24
        
        // Color
		let selfColorAsInt: Int = Int(color) ?? 0
        self.color = NSColor(netHex: selfColorAsInt)
        
    }
}
