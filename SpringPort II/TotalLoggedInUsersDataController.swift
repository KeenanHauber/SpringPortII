//
//  TotalLoggedInUsersDataController.swift
//  SpringPort II
//
//  Created by MasterBel2 on 6/1/17.
//  Copyright © 2017 MasterBel2. All rights reserved.
//

import Cocoa

class TotalLoggedInUsersDataController: NSObject, NSTableViewDelegate, NSTableViewDataSource {
    weak var dataSource: UsersDataSource?
	
    func numberOfRows(in tableView: NSTableView) -> Int {
        guard let dataSource = dataSource else {
			debugPrint("Non-Fatal Error: DataSource not set for TotalLoggedInUserListDataController; number of server users not identified")
			return 0
		}
        return dataSource.userCount()
    }
	
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "channelUserTableCellView"), owner: self)
        guard let tableCellView = cellView as? ChannelUserTableCellView else { fatalError("Invalid Cell Configuration")}
        
        guard let user = dataSource?.user(at: row) else { return cellView }
        
        tableCellView.usernameTextField.stringValue = user.username
		
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
        if user.status.isInGame == true {
            tableCellView.statusImageView.image = #imageLiteral(resourceName: "In Battle Icon")
        } else if user.status.isAway == true {
            tableCellView.statusImageView.image = #imageLiteral(resourceName: "UnreadyCircle")
        } else {
            tableCellView.statusImageView.image = #imageLiteral(resourceName: "ReadyCircle")
        }
        
        return cellView
    }
}
