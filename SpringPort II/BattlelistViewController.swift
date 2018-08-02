//
//  BattlelistViewController.swift
//  SpringPort II
//
//  Created by Keenan Hauber on 29/7/18.
//  Copyright © 2018 MasterBel2. All rights reserved.
//

import Cocoa

protocol BattlelistDisplay {
    
}

protocol BattlelistOptionRepository: class {
    var hidingEmpty: Bool { get }
    var showingLocked: Bool { get }
    var showingPrivate: Bool { get }
}

class BattlelistViewController: NSViewController, BattlelistDisplay {
    @IBOutlet weak var gamesCollectionView: NSCollectionView!
    @IBOutlet weak var battlesCollectionView: NSCollectionView!
    
    // TODO: - Add button for singleplayer game?
    
    // TODO: - Make these all "hide" options
    
    @IBOutlet weak var showLockedCheckbox: NSButton!
    @IBOutlet weak var hideEmptyBattlesCheckbox: NSButton!
    @IBOutlet weak var showPrivateBattlesCheckbox: NSButton!
    
    let interactor: BattlelistInteracting
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        interactor.setDisplayOptionsSource(self)
    }
    
    @IBAction func displayOptionsChanged(_ sender: Any) {
        interactor.displayOptionsChanged()
    }
    
}

extension BattlelistViewController: BattlelistOptionRepository {
    var hidingEmpty: Bool {
        return hideEmptyBattlesCheckbox.state == .on
    }
    
    var showingLocked: Bool {
        return showLockedCheckbox.state == .on
    }
    
    var showingPrivate: Bool {
        return showPrivateBattlesCheckbox.state == .on
    } // combine into one!
    
    
}
