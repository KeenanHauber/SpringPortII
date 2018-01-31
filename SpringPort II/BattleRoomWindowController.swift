//
//  BattleRoomWindowController.swift
//  SpringPort II
//
//  Created by MasterBel2 on 5/1/17.
//  Copyright © 2017 MasterBel2. All rights reserved.
//

import Cocoa

enum BattleStatusOption {
    case Spectator
    case Player
    case Ready
    case Unready
}

protocol BattleRoomWindowControllerDataSource: class {
    func myBattleStatus() -> BattleStatus
    func myBattleNATType() -> NATType
}

protocol BattleRoomWindowControllerDelegate: class {
    func send(_ battleMessage: String)
    func leaveBattle()
    func updateClientBattleStatus(to option: BattleStatusOption)
	func promoteBattle()
}

class BattleRoomWindowController: NSWindowController {
    override var windowNibName: NSNib.Name {
        return NSNib.Name("BattleRoomWindowController")
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        window?.contentView?.backgroundColor = NSColor.darkGray
        belowImageView.isHidden = true
    }
	
	@IBOutlet var battleChatTextView: NSTextView!
    @IBOutlet weak var overImageView: NSImageView!
    @IBOutlet weak var belowImageView: NSImageView!
    @IBOutlet weak var playersTableView: NSTableView!
    @IBOutlet weak var spectatorsTableView: NSTableView!
    @IBOutlet weak var chatTextField: NSTextField!
    @IBOutlet weak var chatButton: NSButton!
    @IBOutlet weak var spectateButton: NSButton!
	@IBOutlet weak var readyButton: NSButton!
	@IBOutlet weak var natTypeTextField: NSTextField!
	
	
	@IBAction func promoteButtonPressed(_ sender: Any) {
		delegate?.promoteBattle()
	}
	
	@IBAction func leaveBattleButtonPressed(_ sender: Any) {
        delegate?.leaveBattle()
    }
	
    @IBAction func spectateButtonPressed(_ sender: Any) {
        if spectateButton.image == #imageLiteral(resourceName: "SpectatorButtonOff") {
            delegate?.updateClientBattleStatus(to: .Spectator)
        } else {
            delegate?.updateClientBattleStatus(to: .Player)
        }
    }
	
    @IBAction func readyButtonPressed(_ sender: Any) {
        if readyButton.image == #imageLiteral(resourceName: "Unready") {
            delegate?.updateClientBattleStatus(to: .Ready)
        } else {
            delegate?.updateClientBattleStatus(to: .Unready)
        }
    }
	
	@IBAction func chatButtonPressed(_ sender: Any) {
		delegate?.send(chatTextField.stringValue)
		chatTextField.stringValue = ""
	}
	@IBAction func enterButtonPressedInTextField(_ sender: Any) {
		delegate?.send(chatTextField.stringValue)
		chatTextField.stringValue = ""
	}
    
    weak var delegate: BattleRoomWindowControllerDelegate?
    weak var dataSource: BattleRoomWindowControllerDataSource?
	
    let playerTableViewDataController = PlayerTableViewDataController()
    let spectatorTableViewDataController = SpectatorTableViewDataController()
    
	
    func setUp() {
        playersTableView.dataSource = playerTableViewDataController
        playersTableView.delegate = playerTableViewDataController
        spectatorsTableView.dataSource = spectatorTableViewDataController
        spectatorsTableView.delegate = spectatorTableViewDataController
		
        guard let natType = dataSource?.myBattleNATType() else { return }
        switch natType {
        case .none:
            natTypeTextField.stringValue = "NAT: .none"
        case .holePunching:
            natTypeTextField.stringValue = "NAT: .holePunching"
        case .fixedSourcePorts:
            natTypeTextField.stringValue = "NAT: .fixedSourcePorts"
        }
    }
    
    func update() { // Currently a non-called function
        playersTableView.reloadData()
        spectatorsTableView.reloadData()
        guard let selfBattleStatus = dataSource?.myBattleStatus() else { return }
        if selfBattleStatus.isPlayer == true {
            spectateButton.image = #imageLiteral(resourceName: "SpectatorButtonOff")
        } else {
            spectateButton.image = #imageLiteral(resourceName: "SpectatorButtonOn")
        }
        if selfBattleStatus.isReady == true {
            readyButton.image = #imageLiteral(resourceName: "Ready")
        } else {
            readyButton.image = #imageLiteral(resourceName: "Unready")
        }
    }
    
}

extension BattleRoomWindowController: BattleRoomDataOutput {
    func updatePlayers() {
        playersTableView.reloadData()
    }
    
    func updateSpectators() {
        spectatorsTableView.reloadData()
    }
    
    func updateBattleStatus() {
        guard let selfBattleStatus = dataSource?.myBattleStatus() else { return }
        if selfBattleStatus.isPlayer == true {
            spectateButton.image = #imageLiteral(resourceName: "SpectatorButtonOff")
        } else {
            spectateButton.image = #imageLiteral(resourceName: "SpectatorButtonOn")
        }
        if selfBattleStatus.isReady == true {
            readyButton.image = #imageLiteral(resourceName: "Ready")
        } else {
            readyButton.image = #imageLiteral(resourceName: "Unready")
        }
    }
    
    func newChatLog(_ log: NSAttributedString) {
        battleChatTextView.textStorage?.setAttributedString(log)
        battleChatTextView.isEditable = false
        battleChatTextView.scrollToEndOfDocument(self)
    }
}

class PlayerTableCellView: NSTableCellView {
    @IBOutlet weak var rankImageView: NSImageView!
    @IBOutlet weak var statusImageView: NSImageView!
    @IBOutlet weak var factionImageView: NSImageView!
    @IBOutlet weak var usernameTextField: NSTextField!
    @IBOutlet weak var trueSkillTextField: NSTextField!
    @IBOutlet weak var countryTextField: NSTextField!
    @IBOutlet weak var teamTextField: NSTextField!
    @IBOutlet weak var allyTextField: NSTextField!
    @IBOutlet weak var colorWell: NSColorWell!
}

class SpectatorTableCellView: NSTableCellView {
    @IBOutlet weak var rankImageView: NSImageView!
    @IBOutlet weak var usernameTextField: NSTextField!
    @IBOutlet weak var trueSkillTextField: NSTextField!
}
