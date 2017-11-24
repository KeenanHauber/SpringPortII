//
//  MapData.swift
//  SpringPort II
//
//  Created by MasterBel2 on 25/11/17.
//  Copyright © 2017 MasterBel2. All rights reserved.
//

import Foundation

struct MapData {
    let name: String
    let fileName: String
    let description: String
    let mapWidth: Int
    let mapHeight: Int
    let tidalStrength: Int
    let windMin: Int
    let windMax: Int
    let mapGravity: Int
    let resourceCount: Int
    let checksum: UInt32
    let miniMapData: [UInt16]
}
