//
//  BattleListDataController.swift
//  SpringPort II
//
//  Created by MasterBel2 on 4/1/17.
//  Copyright © 2017 MasterBel2. All rights reserved.
//

import Cocoa

protocol OpenBattleListDataControllerDataSource: class/*, BattleListCollectionViewItemDelegate*/ {
    func battleCount() -> Int
    func battle(for indexPath: IndexPath) -> Battle
    func founder(for battle: Battle) -> User
	func has()
}

class OpenBattleListDataController: NSObject, NSCollectionViewDelegate, NSCollectionViewDataSource {
    weak var dataSource: BattleListDataSource?
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.openBattleCount() ?? 0
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "BattleListCollectionViewItem"), for: indexPath) as! BattleListCollectionViewItem
		
		guard let dataSource = dataSource else { return item }
        let battle = dataSource.openBattle(for: indexPath)
        let text = "\(battle.playerCount)/\(battle.maxPlayers)"
        
        item.descriptionTextField.stringValue = (battle.title)
        item.descriptionTextField.textColor = NSColor.blue
		
        item.engineVersionTextField.stringValue = (battle.engineVersion)
		
		if dataSource.has(engine: battle.engineVersion) == true {
			item.engineVersionTextField.textColor = NSColor.green
		} else {
			item.engineVersionTextField.textColor = NSColor.red
		}
		
		item.gameNameTextField.stringValue = (battle.gameName)
		
		if dataSource.has(battle.gameName) == true {
			item.gameNameTextField.textColor = NSColor.green
		} else {
			item.gameNameTextField.textColor = NSColor.red
		}
		
		item.playersTextField.stringValue = text
        if battle.playerCount == battle.maxPlayers {
            item.playersTextField.textColor = NSColor.red
        } else {
            item.playersTextField.textColor = NSColor.green
        }
        item.mapNameTextField.stringValue = (battle.mapName)
		if dataSource.hasMap(with: battle.mapHash) {// TODO: -- Fix!!
			item.mapNameTextField.textColor = NSColor.green
		} else {
			item.mapNameTextField.textColor = NSColor.red
		}

        item.hostNameTextField.stringValue = battle.founder
        item.hostNameTextField.textColor = NSColor.blue
		
        
        if battle.isLocked == true || battle.passworded == true {
            item.statusImageView.image = #imageLiteral(resourceName: "Locked Icon")
        } else if founder(for: battle).status.isInGame == true {
            item.statusImageView.image = #imageLiteral(resourceName: "In Battle Icon")
        } else {
            item.statusImageView.image = #imageLiteral(resourceName: "ReadyCircle")
        }
        
        item.battleId = battle.battleId
        item.delegate = self
        
        return item
    }
    
    func founder(for battle: Battle) -> User {
		guard let dataSource = dataSource else {
			debugPrint("Non-Fatal Error: Cannot find battle founder: No DataSource set. Returning a default user instead. (This should never happen)!!")
			return User() 
		}
        return dataSource.founder(for: battle)
    }
}

extension OpenBattleListDataController: BattleListCollectionViewItemDelegate {
    func request(toJoin battle: String, with password: String) {
        dataSource?.request(toJoin: battle, with: password)
    }
}

extension OpenBattleListDataController: NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return NSSize(width: collectionView.bounds.width, height: 49)
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, insetForSectionAt section: Int) -> NSEdgeInsets {
        return NSEdgeInsetsZero
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
