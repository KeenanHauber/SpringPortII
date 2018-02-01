//
//  UpdatedBattleInfo.swift
//  OSXSpringLobby
//
//  Created by Belmakor on 1/07/2016.
//  Copyright © 2016 MasterBel2. All rights reserved.
//

import Foundation

class UpdatedBattleInfo {

    let battleId: String
    let spectatorCount: Int
    let isLocked: Bool
    let mapHash: UInt32
    let mapName: String

    // UPDATEBATTLEINFO battleID spectatorCount locked mapHash {mapName}
    init?(components: [String]) {
        guard components.count >= 2 else { return nil }

        battleId = components[1]
        spectatorCount = Int(components[2]) ?? 0
        isLocked = components[3] != "0"
        mapHash = UInt32(components[4]) ?? 0

        let mapNameComponents = components[5..<components.count]
        mapName = mapNameComponents.joined(separator: " ")
    }
}
