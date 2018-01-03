//
//  SpectatorTableViewDataController.swift
//  SpringPort II
//
//  Created by MasterBel2 on 5/1/17.
//  Copyright © 2017 MasterBel2. All rights reserved.
//

import Cocoa

class SpectatorTableViewDataController: NSObject, NSTableViewDelegate, NSTableViewDataSource {
    weak var dataSource: BattleRoomDataSource?
    func numberOfRows(in tableView: NSTableView) -> Int {
        guard let dataSource = dataSource else {
			debugPrint("Non-Fatal Error: No DataSource set for SpectatorTableViewDataController")
			return 0
		}
        return (dataSource.numberOfSpectatorsInCurrentBattle())
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "spectatorTableCellView"), owner: self)
        guard let tableCellView = cellView as? SpectatorTableCellView else { fatalError("Invalid Cell Configuration")}
        
        guard let user = dataSource?.spectator(at: row) else { return cellView}
        
        tableCellView.usernameTextField.stringValue = user.username
        
//        if user.country == "AU" {
//            tableCellView.flagImageView.image = #imageLiteral(resourceName: "Aussie Flag")
//        }
        
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
//            if battleStatus.synced == .synced || battleStatus.synced == .unknown {
//                tableCellView.statusImageView.image = #imageLiteral(resourceName: "Caution")
//            } else if battleStatus.isReady == true {
//                tableCellView.statusImageView.image = #imageLiteral(resourceName: "OpenBattleIcon")
//            } else {
//                tableCellView.statusImageView.image = #imageLiteral(resourceName: "Unready")
//            }
            tableCellView.trueSkillTextField.stringValue = String(battleStatus.trueSkill)
//            tableCellView.teamTextField.stringValue = String(battleStatus.teamNumber)
//            tableCellView.allyTextField.stringValue = String(battleStatus.allyNumber)
//            tableCellView.colorWell.color = battleStatus.color
        }
        
        if let trueSkills = dataSource?.trueSkillDictionary() {
            let lowerCaseName = user.username.lowercased()
            if let name = trueSkills[lowerCaseName] {
                tableCellView.trueSkillTextField.stringValue = name
            }
        }
        
        return cellView
    }
}
