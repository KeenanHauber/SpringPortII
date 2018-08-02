//
//  BattleListInteractor.swift
//  SpringPort II
//
//  Created by Keenan Hauber on 25/7/18.
//  Copyright © 2018 MasterBel2. All rights reserved.
//

import Foundation

protocol BattlelistInteracting {
    func selectedBattle(at index: Int)
    func selectedGame(at index: Int)
    func displayOptionsChanged()
    func setDisplayOptionsSource(_ repository: BattlelistOptionRepository)
}

class BattleListInteractor: BattlelistInteracting {
    
    let presenter: BattlelistPresenting
    let repository: BattleRepository
    let gameRepository: GameRepository
    weak var displayOptionRepository: BattlelistOptionRepository?
    
    init(presenter: BattlelistPresenting, battleRepository: BattleRepository, gamesRepository: GameRepository) {
        self.presenter = presenter
        self.repository = battleRepository
        self.gameRepository = gamesRepository
    }
    
    func selectedBattle(at index: Int) {
        let battle = repository.battle(at: index)
    }
    
    func selectedGame(at index: Int) {
        
    }
    
    func battleListUpdated(battles: [Battle]) {
        
    }
    
    
    func displayOptionsChanged() {
        
    }
    
    func setDisplayOptionsSource(_ repository: BattlelistOptionRepository) {
        self.displayOptionRepository = repository
    }
    
}

