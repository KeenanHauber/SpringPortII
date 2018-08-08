//
//  BattleListInteractor.swift
//  SpringPort II
//
//  Created by MasterBel2 on 25/7/18.
//  Copyright © 2018 MasterBel2. All rights reserved.
//

import Foundation

protocol BattlelistInteracting {
    func selectedBattle(at index: Int)
    func selectedGame(at index: Int)
    func displayOptionsChanged()
    func setDisplayOptionsSource(_ repository: BattlelistOptionRepository)
}

protocol BattleNotificatee: class { // uh
    func battlesUpdated()
}

struct BattleListDisplayOptions {
    var showLocked: Bool
    var showPrivate: Bool
    var showEmpty: Bool
    var games: [String]
}

class BattleListInteractor: BattlelistInteracting {
    
    var sorting: Sorting = .PlayersDescending
    
    var battleIndices: [Int : String] = [:]
    
    enum Sorting {
        case PlayersDescending
        case PlayersAscending
        case HostDescending
        case HostAscending
    }
    
    let presenter: BattlelistPresenting
    let repository: BattleRepository
    let gameRepository: GameRepository
    let server: TASServer
    
    var displayOptions: BattleListDisplayOptions {
        guard let repository = displayOptionRepository else {
            debugPrint("NoV")
            return BattleListDisplayOptions(showLocked: true, showPrivate: true, showEmpty: true, games: [])
        }
        let showLocked = repository.showingLocked
        let showPrivate = repository.showingPrivate
        let showEmpty = !repository.hidingEmpty
        let games = repository.games
        return BattleListDisplayOptions(showLocked: showLocked, showPrivate: showPrivate, showEmpty: showEmpty, games: games)
    }
    
    weak var displayOptionRepository: BattlelistOptionRepository?
    
    init(server: TASServer, presenter: BattlelistPresenting, battleRepository: BattleRepository, gamesRepository: GameRepository) {
        self.server = server
        self.presenter = presenter
        self.repository = battleRepository
        self.gameRepository = gamesRepository
    }
    
    func selectedBattle(at index: Int) {
        guard let id = battleIndices[index] else {return}
        guard let battle = repository.battle(id) else {return}
//        let battle = repository.battle(at: index)
    }
    
    func selectedGame(at index: Int) {
        
    }
    
    func battleListUpdated(battles: [Battle]) {
        var index = 0
        let sortedBattles = battles.sorted { $0.playerCount > $1.playerCount }
        battleIndices = [ : ]
        sortedBattles.forEach { battle in
            battleIndices[index] = battle.battleId
            index += 1
        }
    }
    
    
    func displayOptionsChanged() {
        
    }
    
    func setDisplayOptionsSource(_ repository: BattlelistOptionRepository) {
        self.displayOptionRepository = repository
    }
    
}

extension BattleListInteractor: BattleNotificatee {
    func battlesUpdated() {
        let displayOptions = self.displayOptions
        
        let battles = repository.battles(for: displayOptions)
        presenter.present(displayOptions.games, battles: battles)
    }
}

