//
//  AppDelegate.swift
//  SpringPort II
//
//  Created by MasterBel2 on 3/1/17.
//  Copyright © 2017 MasterBel2. All rights reserved.
//

import Cocoa

func timeStamp() -> String {
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateFormat = "HH:mm:ss"
    dateFormatter.timeZone = TimeZone.current
    
    let timestamp = dateFormatter.string(from: Date())
    
    return timestamp
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate { // Each specific step - make an object for it? Completes its purpose, then can be taken down
    var windows: [NSWindow] = []
    var server: TASServer?
    var username: String?
    var password: String?
    var ingameTimeAsString: String = ""
    var ingameTime: Int = 0
    
    // TODO: Joining battles that use hole punching -- var battleUDPInterface: BattleUDPInterface?
    var primaryCoordinator: PrimaryCoordinator!
    var cacheManager: CacheManager!
    
    @IBOutlet weak var singlePlayerGameMenuItem: NSMenuItem!
    
    @IBOutlet weak var relaunchSpringMenuItem: NSMenuItem! // When selected will join an already in-game game
    @IBAction func relaunchSpringMenuItemPressed(_ sender: Any) {
        primaryCoordinator.relaunchSpring()
    }
    @IBAction func singlePlayerGameMenuItemPressed(_ sender: Any) {
        primaryCoordinator.mainWindowController.openSinglePlayerMenu()
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let primaryCoordinator = PrimaryCoordinator()
        primaryCoordinator.setUp()
        self.primaryCoordinator = primaryCoordinator
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        
    }
    
//    func callCacheManager() {
//        let cacheManager = CacheManager()
//        cacheManager.loadUnitSyncWrapper()
//        cacheManager.loadMaps2()
//        self.cacheManager = cacheManager
//    }
}
