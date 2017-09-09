//
//  ChatUsersCollectionViewItem.swift
//  SpringPort II
//
//  Created by MasterBel2 on 4/1/17.
//  Copyright © 2017 MasterBel2. All rights reserved.
//

import Cocoa

protocol ChatUsersCollectionViewItemDelegate: class {
    
}

class ChatUsersCollectionViewItem: NSCollectionViewItem {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    var channel: Channel?
    weak var delegate: ChatUsersCollectionViewItemDelegate?
}

extension ChatUsersCollectionViewItem: NSTableViewDelegate {
    
}

extension ChatUsersCollectionViewItem: NSTableViewDataSource {
    
}

class ChatUsersCollectionViewTableCellView: NSTableCellView {
    @IBOutlet weak var rankImageView: NSImageView!
    @IBOutlet weak var userNameTextField: NSTextField!
}
