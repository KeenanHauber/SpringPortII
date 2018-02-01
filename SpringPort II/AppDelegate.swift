//
//  AppDelegate.swift
//  SpringPort II
//
//  Created by MasterBel2 on 3/1/17.
//  Copyright © 2017 MasterBel2. All rights reserved.
//

import Cocoa

func timeStamp() -> String { // Make this a class thing?
    let dateFormatter = DateFormatter()

    dateFormatter.dateFormat = "HH:mm:ss"
    dateFormatter.timeZone = TimeZone.current

    let timestamp = dateFormatter.string(from: Date())

    return timestamp
}



@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var primaryCoordinator: PrimaryCoordinator! // ???
    
    @IBOutlet weak var singlePlayerGameMenuItem: NSMenuItem!
    @IBOutlet weak var relaunchSpringMenuItem: NSMenuItem! // When selected will join an already in-game game
	
	@IBAction func relaunchSpringMenuItemPressed(_ sender: Any) {
        primaryCoordinator.relaunchSpring()
    }
	
    @IBAction func singlePlayerGameMenuItemPressed(_ sender: Any) {
        primaryCoordinator.mainWindowController.openSinglePlayerMenu()
    }
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		let primaryCoordinator = PrimaryCoordinator(menuDelegate: self)
		let cache: Cache = CacheManager()
		cache.setup()
        primaryCoordinator.setUp()
        self.primaryCoordinator = primaryCoordinator
		relaunchSpringMenuItem.isEnabled = false
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        
    }
}

protocol MenuDelegate: class {
	func disableSpectate()
	func enableSpectate()
	func disableSoloGame()
	func enableSoloGame()
}

extension AppDelegate: MenuDelegate {
	func disableSpectate() { relaunchSpringMenuItem.isEnabled = false }
	func enableSpectate() { relaunchSpringMenuItem.isEnabled = true }
	
	func disableSoloGame() { singlePlayerGameMenuItem.isEnabled = false }
	func enableSoloGame() { singlePlayerGameMenuItem.isEnabled = true }
}
