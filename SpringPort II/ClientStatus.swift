//
//  ClientStatus.swift
//  OSXSpringLobby
//
//  Created by Belmakor on 7/07/2016.
//  Copyright © 2016 MasterBel2. All rights reserved.
//

import Foundation

struct ClientStatus {

    enum Rank: Int {
        case a = 0 // 0+ hours
        case b = 1 // 5+ hours
        case c = 2 // 15+ hours
        case d = 3 // 30+ hours
        case e = 4 // 100+ hours
        case f = 5 // 300+ hours
        case g = 6 // 1000+ hours
        case h = 7 // 3000+ hours
    }

    let isInGame: Bool
    let isAway: Bool
    let rank: Rank
    let isServerMod: Bool
    let isBot: Bool

    init(statusString: String) {
        let statusValue = Int(statusString) ?? 0
        isInGame = (statusValue & 0b1) == 0b1
        isAway = (statusValue & 0b10) == 0b10
        rank = Rank(rawValue: (statusValue & 0b11100) >> 2)!
        isServerMod = (statusValue & 0b100000) == 0b100000
        isBot = (statusValue & 0b1000000) == 0b1000000
    }

}

extension ClientStatus.Rank: CustomStringConvertible {

    var insignia: String {
        switch self {
        case .a: return "−" // ∸
        case .b: return "=" // ≐
        case .c: return "≡" // ⩧
        case .d: return "≣"
        case .e: return "⊟" // ∺
        case .f: return "⊡" // ⩷
        case .g: return "⧇"
        case .h: return "⧈" // ⧆
        }
    }

    var description: String {
        switch self {
        case .a: return "< 5 hours"
        case .b: return "5+ hours"
        case .c: return "15+ hours"
        case .d: return "30+ hours"
        case .e: return "100+ hours"
        case .f: return "300+ hours"
        case .g: return "1000+ hours"
        case .h: return "3000+ hours"
        }
    }
}
