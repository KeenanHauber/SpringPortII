//
//  UserInfo.swift
//  OSXSpringLobby
//
//  Created by Belmakor on 1/07/2016.
//  Copyright © 2016 MasterBel2. All rights reserved.
//

import Foundation

class User: NSObject {

    let username: String
    let country: String // ISO 3166 country code
    let accountId: String?

    var status: ClientStatus
    
    var battleStatus: BattleStatus?

    init?(message: String) {
        let components = message.components(separatedBy: " ")
        guard components.count >= 4 else { return nil }
        username = components[1]
        country = components[2]
        if components.count == 5 {
            accountId = components[4]
        } else {
            accountId = nil
        }
        status = ClientStatus(statusString: "0")
    }
    
    override init() {
        username = "foo"
        country = "XX"
        status = ClientStatus(statusString: "0")
        accountId = nil
        super.init()
    }
    
}
