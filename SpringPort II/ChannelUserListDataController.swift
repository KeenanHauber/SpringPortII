//
//  ChannelUserListDataController.swift
//  SpringPort II
//
//  Created by MasterBel2 on 4/1/17.
//  Copyright © 2017 MasterBel2. All rights reserved.
//

import Cocoa

// The following protocol is defined in ChannelDataController.swift

//protocol ChannelDataSource: class {
//    func channelUsers() -> [User]
//    func channelUserCount() -> Int
//}

class ChannelUserListDataController: NSObject, NSTableViewDelegate, NSTableViewDataSource {
    weak var dataSource: ChannelDataSource?
    func numberOfRows(in tableView: NSTableView) -> Int {
        guard let _ = dataSource else { return 0 }
        return dataSource!.channelUserCount()
    }
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellView = tableView.make(withIdentifier: "channelUserTableCellView", owner: self)
        guard let tableCellView = cellView as? ChannelUserTableCellView else { fatalError("Invalid Cell Configuration")}
        
        guard let users = dataSource?.channelUsers() else { return cellView }
        
        guard users.count > row else { return cellView }
        let user = users[row]
        
        tableCellView.usernameTextField.stringValue = user.username
        switch user.status.rank {
        case .a:
            tableCellView.rankImageView.image = #imageLiteral(resourceName: "Rank 1: Newbie")
        case .b:
            tableCellView.rankImageView.image = #imageLiteral(resourceName: "Rank 2")
        case .c:
            tableCellView.rankImageView.image = #imageLiteral(resourceName: "Rank 3")
        case .d:
            tableCellView.rankImageView.image = #imageLiteral(resourceName: "Rank 4")
        case .e:
            tableCellView.rankImageView.image = #imageLiteral(resourceName: "Rank 5")
        case .f:
            tableCellView.rankImageView.image = #imageLiteral(resourceName: "Rank 6")
        case .g:
            tableCellView.rankImageView.image = #imageLiteral(resourceName: "Rank 7")
        case .h:
            tableCellView.rankImageView.image = #imageLiteral(resourceName: "Rank 8")
        }
        if user.status.isBot == true {
            tableCellView.statusImageView.image = #imageLiteral(resourceName: "ServerStack")
        } else if user.status.isInGame == true {
            tableCellView.statusImageView.image = #imageLiteral(resourceName: "In Battle Icon")
        } else if user.status.isAway == true {
            tableCellView.statusImageView.image = #imageLiteral(resourceName: "UnreadyCircle")
        } else {
            tableCellView.statusImageView.image = #imageLiteral(resourceName: "ReadyCircle")
        }
        
        return cellView
    }
}
