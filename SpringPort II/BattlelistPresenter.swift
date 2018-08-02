//
//  BattlelistPresenter.swift
//  SpringPort II
//
//  Created by Keenan Hauber on 25/7/18.
//  Copyright © 2018 MasterBel2. All rights reserved.
//

import Cocoa

protocol BattlelistPresenting {
    func present(_ games: [String], battles: [Battle])
}

class BattleListPresenter: BattlelistPresenting {
    let display: BattlelistDisplay
    
    init(display: BattlelistDisplay) {
        self.display = display
    }
    
    func present(_ games: [String], battles: [Battle]) {
        let gameCount = games.count
        var sections: [CollectionViewSection] = []
        for game in games {
            var items: [NSCollectionViewItem] = []
            for battle in battles {
                if battle.gameName == game {
                    items.append(battleListItem(for: battle))
                }
            }
            var section = CollectionViewSection(title: game, items: [])
            sections.append(section)
        }
        display.display(sections)
    }
    
    private func battleListItem(for battle: Battle) -> NSCollectionViewItem { // Should this be moved to the display?
        
        // TODO: item initialised from battle? Or maybe a cellcreatorobject?
        
        let something = false
        
        let ingame = ""
        
        let item = BattleListCollectionViewItem()
        item.set(description: battle.description)
        item.set(playerCount: "\(battle.playerCount)/\(battle.maxPlayers)", full: (battle.playerCount == battle.maxPlayers))
        item.set(host: battle.host)
        item.set(ingame: ingame)
        item.set(gameName: battle.gameName, hasGame: something)
        item.set(mapName: battle.mapName, hasMap: something)
        return item
    }
    
}

