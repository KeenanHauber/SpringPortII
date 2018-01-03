//
//  BattleListCollectionViewItem.swift
//  SpringPort II
//
//  Created by MasterBel2 on 4/1/17.
//  Copyright © 2017 MasterBel2. All rights reserved.
//

import Cocoa

protocol BattleListCollectionViewItemDelegate: class {
    func request(toJoin battle: String, with password: String)
}

class BattleListCollectionViewItem: NSCollectionViewItem {
    var battleId: String = ""
    weak var delegate: BattleListCollectionViewItemDelegate?
    override var nibName: NSNib.Name {
        return NSNib.Name("BattleListCollectionViewItem")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    @IBOutlet weak var descriptionTextField: NSTextField!
    @IBOutlet weak var statusImageView: NSImageView!
    @IBOutlet weak var rankImageView: NSImageView!
    @IBOutlet weak var playersTextField: NSTextField!
    @IBOutlet weak var mapNameTextField: NSTextField!
    @IBOutlet weak var gameNameTextField: NSTextField!
    @IBOutlet weak var engineVersionTextField: NSTextField!
    @IBOutlet weak var hostNameTextField: NSTextField!
    @IBAction func doubleClicked(_ sender: Any) {
        let password = ""
        delegate?.request(toJoin: battleId, with: password)
    }
}
