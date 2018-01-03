//
//  MainWindowController.swift
//  SpringPort II
//
//  Created by MasterBel2 on 3/1/17.
//  Copyright © 2017 MasterBel2. All rights reserved.
//

import Cocoa

protocol MainWindowControllerDelegate: SinglePlayerViewControllerDelegate { // "class" requirement is implied
    func sendChannelMessage(message: String)
	func selectChannel(atIndex index: Int) //selectChannel(at index: Int)
    func login(to server: String, with username: String, and password: String)
    func register(on server: String, with username: String, and password: String)
}

class MainWindowController: NSWindowController {
    var channelUserListDataController: ChannelUserListDataController?
    var openBattleListDataController: OpenBattleListDataController?
    var totalLoggedInUsersDataController: TotalLoggedInUsersDataController?
    var singlePlayerWindow: NSWindow?
    var loginWindow: NSWindow?
    var loginViewController: LoginViewController?
    weak var delegate: MainWindowControllerDelegate?
    
    override var windowNibName: String {
        return "MainWindowController"
    }
    override func windowDidLoad() {
        window?.title = "MacTASClient"
    }
    
    @IBOutlet weak var battlesReadyToGoCollectionView: NSCollectionView!
    @IBOutlet var chatTextView: NSTextView!
    @IBOutlet weak var chatButton: NSButton!
    @IBAction func chatButtonPressed(_ sender: Any) {
        delegate?.sendChannelMessage(message: chatMessageTextField.stringValue)
        chatMessageTextField.stringValue = ""
    }
    @IBOutlet weak var chatMessageTextField: NSTextField!
    @IBAction func enterButtonPressedInChatMessageTextField(_ sender: Any) {
        delegate?.sendChannelMessage(message: chatMessageTextField.stringValue)
        chatMessageTextField.stringValue = ""
    }
    @IBOutlet weak var ingameTimeTextField: NSTextField!
    @IBOutlet weak var rankNameTextField: NSTextField!
    @IBOutlet weak var rankImageView: NSImageView!
    @IBOutlet weak var userNameTextField: NSTextField!
    
    @IBOutlet weak var channelUsersTableView: NSTableView!
    @IBOutlet weak var totalLoggedInUsersTableView: NSTableView!
    
    @IBOutlet weak var channelSegmentedControl: NSSegmentedControl!
    @IBAction func channelSelectionChanged(_ sender: Any) {
        delegate?.selectChannel(atIndex: channelSegmentedControl.selectedSegment)
    }
    @IBOutlet weak var blurView: BlurView!
    @IBOutlet weak var notLoggedInAlert: NSTextField!
    @IBOutlet weak var singlePlayerButton: NSTextField!
    @IBOutlet weak var singlePlayerClickGestureRecogniser: NSClickGestureRecognizer!
    @IBAction func openSinglePlayerMenu(_ sender: Any) {
        openSinglePlayerMenu()
    }

    
    func hideSinglePlayerWarning() {
        blurView.isHidden = true
        notLoggedInAlert.isHidden = true
        singlePlayerButton.isHidden = true
    }
    
    func setUp() {
        let channelUserListDataController = ChannelUserListDataController()
        let openBattleListDataController = OpenBattleListDataController()
        let totalLoggedInUsersDataController = TotalLoggedInUsersDataController()
        guard let _ = battlesReadyToGoCollectionView else { return }
        guard let _ = channelUsersTableView else { return }
        battlesReadyToGoCollectionView.delegate = openBattleListDataController
        battlesReadyToGoCollectionView.dataSource = openBattleListDataController
        channelUsersTableView.dataSource = channelUserListDataController
        channelUsersTableView.delegate = channelUserListDataController
        totalLoggedInUsersTableView.dataSource = totalLoggedInUsersDataController
        totalLoggedInUsersTableView.delegate = totalLoggedInUsersDataController

        self.channelUserListDataController = channelUserListDataController
        self.openBattleListDataController = openBattleListDataController
        self.totalLoggedInUsersDataController = totalLoggedInUsersDataController
		
        window?.contentView?.backgroundColor = NSColor.black
    }
    
    func updateUserTables() {
        channelUsersTableView.reloadData()
    }
    
    func openSinglePlayerMenu() {
        let window = NSWindow()
        let singlePlayerViewController = SinglePlayerViewController()
        singlePlayerViewController.delegate = self.delegate
        window.contentViewController = singlePlayerViewController
        window.makeKeyAndOrderFront(self)
        window.title = "Single Player"
        self.singlePlayerWindow = window
    }
    
    func presentLoginSheet() {
        let loginViewController = LoginViewController()
        loginViewController.delegate = self
        let loginWindow = NSWindow(contentViewController: loginViewController)
        guard let window = window else { return }
        window.beginSheet(loginWindow, completionHandler: nil)
        self.loginWindow = loginWindow
        self.loginViewController = loginViewController
    }
}

extension MainWindowController: ChannelDataOutput {
    func channelListUpdated(_ count: Int) {
        channelSegmentedControl.segmentCount = count
        for index in 0..<count {
            channelSegmentedControl.setLabel(channelUserListDataController?.dataSource?.channelName(for: index) ?? "", forSegment: index) // This is really bad the way you reach in here…
        }
    }
    func newChatLogForSelectedChannel(_ log: NSAttributedString) {
        chatTextView.textStorage?.setAttributedString(log)
        chatTextView.isEditable = false
        chatTextView.scrollToEndOfDocument(self)
    }
    
    func playerListUpdated() {
        channelUsersTableView.reloadData()
    }
}

extension MainWindowController: ServerMessageOutput {
    func setIngameTime(as time: Int) {
        let hours = (time/60)
        ingameTimeTextField.stringValue = "Ingame Time: \(time) minutes (\(hours) hours)"
        // TODO: -- Rank from the ClientStatus info!
		// Except probably not here because, well.
    }
}

extension MainWindowController: BattleListDataOutput {
    func reloadBattleListData() {
        battlesReadyToGoCollectionView.reloadData()
    }
}

extension MainWindowController: UsersDataOutput {
    func userListUpdated() {
        totalLoggedInUsersTableView.reloadData()
    }
    
    func userInfoUpdated(to status: ClientStatus) {
        switch status.rank {
        case .a:
            rankNameTextField.stringValue = "Rank 1:"
            rankImageView.image = #imageLiteral(resourceName: "Rank 1: Newbie")
            rankImageView.backgroundColor = NSColor.black
			
        case .b:
            rankNameTextField.stringValue = "Rank 2:"
            rankImageView.image = #imageLiteral(resourceName: "Rank 2")
            rankImageView.backgroundColor = NSColor.black
			
        case .c:
            rankNameTextField.stringValue = "Rank 3:"
            rankImageView.image = #imageLiteral(resourceName: "Rank 3")
            rankImageView.backgroundColor = NSColor.black
			
			
        case .d:
            rankNameTextField.stringValue = "Rank 4:"
            rankImageView.image = #imageLiteral(resourceName: "Rank 4")
            rankImageView.backgroundColor = NSColor.black
			
        case .e:
            rankNameTextField.stringValue = "Rank 5:"
            rankImageView.image = #imageLiteral(resourceName: "Rank 5")
            rankImageView.backgroundColor = NSColor.black
			
        case .f:
            rankNameTextField.stringValue = "Rank 6:"
            rankImageView.image = #imageLiteral(resourceName: "Rank 6")
            rankImageView.backgroundColor = NSColor.black
			
        case .g:
            rankNameTextField.stringValue = "Rank 7:"
            rankImageView.image = #imageLiteral(resourceName: "Rank 7")
            rankImageView.backgroundColor = NSColor.black
			
        case .h:
            rankNameTextField.stringValue = "Rank 8:"
            rankImageView.image = #imageLiteral(resourceName: "Rank 8")
            rankImageView.backgroundColor = NSColor.black
			
		case .i:
			rankNameTextField.stringValue = "Error: Could not parse rank."
			rankImageView.image = #imageLiteral(resourceName: "Caution")
			rankImageView.backgroundColor = NSColor.black
        }
    }
}

extension MainWindowController: LoginViewControllerDelegate {
    func loginRequested(for username: String, with password: String, to server: String) {
        delegate?.login(to: server, with: username, and: password)
    }
    func registerRequested(for username: String, with password: String, to server: String) {
        delegate?.register(on: server, with: username, and: password)
    }
}

class ChannelUserTableCellView: NSTableCellView {
    @IBOutlet weak var statusImageView: NSImageView!
    @IBOutlet weak var rankImageView: NSImageView!
    @IBOutlet weak var usernameTextField: NSTextField!
}
