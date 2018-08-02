//
//  BattlelistViewController.swift
//  SpringPort II
//
//  Created by Keenan Hauber on 29/7/18.
//  Copyright © 2018 MasterBel2. All rights reserved.
//

import Cocoa

protocol BattlelistDisplay {
    func display(_ sections: [CollectionViewSection])
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(interactor: BattlelistInteracting) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        interactor.setDisplayOptionsSource(self)
        
    }
    
    @IBAction func displayOptionsChanged(_ sender: Any) {
        interactor.displayOptionsChanged()
    }
    
    func display(_ sections: [CollectionViewSection]) {
        
        battlesCollectionView.reloadData()
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
