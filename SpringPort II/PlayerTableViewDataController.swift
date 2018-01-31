//
//  PlayerTableViewDataController.swift
//  SpringPort II
//
//  Created by MasterBel2 on 5/1/17.
//  Copyright © 2017 MasterBel2. All rights reserved.
//

import Cocoa



class PlayerTableViewDataController: NSObject, NSTableViewDelegate, NSTableViewDataSource {
    weak var dataSource: BattleRoomDataSource?
    func numberOfRows(in tableView: NSTableView) -> Int {
        guard let dataSource = dataSource else {
			debugPrint("Non-Fatal Error: No DataSource set for PlayerTableViewDataController")
			return 0
		}
        return (dataSource.numberOfPlayersInCurrentBattle())
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "playerTableCellView"), owner: self)
        guard let tableCellView = cellView as? PlayerTableCellView else { fatalError("Invalid Cell Configuration")}
		
		guard let dataSource = dataSource else { return cellView }
		
		let user = dataSource.player(at: row)
        
        tableCellView.usernameTextField.stringValue = user.username
        
        // TODO: fix ui to work with the below
        
        let country = user.country
        tableCellView.countryTextField.stringValue = country.flag
        tableCellView.countryTextField.toolTip = country.name
        
        if user.status.isBot == true {
            tableCellView.rankImageView.image = #imageLiteral(resourceName: "ServerStack")
        } else {
            switch user.status.rank {
            case .a: tableCellView.rankImageView.image = #imageLiteral(resourceName: "Rank 1: Newbie")
            case .b: tableCellView.rankImageView.image = #imageLiteral(resourceName: "Rank 2")
            case .c: tableCellView.rankImageView.image = #imageLiteral(resourceName: "Rank 3")
            case .d: tableCellView.rankImageView.image = #imageLiteral(resourceName: "Rank 4")
            case .e: tableCellView.rankImageView.image = #imageLiteral(resourceName: "Rank 5")
            case .f: tableCellView.rankImageView.image = #imageLiteral(resourceName: "Rank 6")
            case .g: tableCellView.rankImageView.image = #imageLiteral(resourceName: "Rank 7")
            case .h: tableCellView.rankImageView.image = #imageLiteral(resourceName: "Rank 8")
			case .i: tableCellView.rankImageView.image = #imageLiteral(resourceName: "Caution")
            }
        }
        
        
        if let battleStatus = user.battleStatus {
			if battleStatus.synced == .unsynced || battleStatus.synced == .unknown {// TODO: -- Make this a switch case thing
                tableCellView.statusImageView.image = #imageLiteral(resourceName: "Caution")
            } else if user.status.isInGame == true {
                tableCellView.statusImageView.image = #imageLiteral(resourceName: "In Battle Icon")
            } else if battleStatus.isReady == true {
                tableCellView.statusImageView.image = #imageLiteral(resourceName: "ReadyCircle")
            } else {
                tableCellView.statusImageView.image = #imageLiteral(resourceName: "UnreadyCircle")
            }

            tableCellView.teamTextField.stringValue = String(battleStatus.teamNumber+1)
            tableCellView.allyTextField.stringValue = String(battleStatus.allyNumber+1)
            tableCellView.colorWell.color = battleStatus.color
        }
        let trueSkills = dataSource.trueSkillDictionary()
		let lowerCaseName = user.username.lowercased()
		if let name = trueSkills[lowerCaseName] {
			tableCellView.trueSkillTextField.stringValue = name
		}
        
        return cellView
    }
}
