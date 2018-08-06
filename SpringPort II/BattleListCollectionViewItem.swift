//
//  BattleListCollectionViewItem.swift
//  SpringPort II
//
//  Created by MasterBel2 on 2/8/18.
//  Copyright © 2018 MasterBel2. All rights reserved.
//

import Cocoa

class BattleListCollectionViewItem: NSCollectionViewItem {
    @IBOutlet weak var descriptionField: NSTextField!
    @IBOutlet weak var playerCountField: NSTextField! // No spectators at this point?
    @IBOutlet weak var hostField: NSTextField!
    @IBOutlet weak var ingameField: NSTextField!
    @IBOutlet weak var gameField: NSTextField!
    @IBOutlet weak var mapField: NSTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    func set(description: String) {
        descriptionField.stringValue = description
        descriptionField.textColor = neutralColor
    }

    func set(playerCount: String, full: Bool) {
        playerCountField.stringValue = playerCount
        playerCountField.textColor = color(full)
    }
    
    func set(host hostName: String) {
        hostField.stringValue = hostName
        hostField.textColor = neutralColor
    }
    
    func set(gameName: String, hasGame: Bool) {
        gameField.stringValue = gameName
        gameField.textColor = color(hasGame)
    }
    
    func set(mapName: String, hasMap: Bool) {
        mapField.stringValue = mapName
        mapField.textColor = color(hasMap)
    }
    
    func set(ingame: String) {
        ingameField.stringValue = ingame
        ingameField.textColor = neutralColor
    }
    
    func color(_ bool: Bool) -> NSColor {
        if bool {
            return positiveColor
        } else {
            return negativeColor
        }
    }
    
    let negativeColor = NSColor.systemRed
    let positiveColor = NSColor.systemGreen
    let neutralColor = NSColor.systemGray
}
