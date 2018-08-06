//
//  GameRepository.swift
//  SpringPort II
//
//  Created by MasterBel2 on 29/7/18.
//  Copyright © 2018 MasterBel2. All rights reserved.
//

import Foundation

protocol GameRepository {
    
}

class DefaultGameRepository: GameRepository {
    let games: [Game] = []
}
