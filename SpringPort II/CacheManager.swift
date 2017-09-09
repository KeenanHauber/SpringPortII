//
//  CacheManager.swift
//  SpringPort II
//
//  Created by MasterBel2 on 7/1/17.
//  Copyright © 2017 MasterBel2. All rights reserved.
//

import Cocoa
//import Zip

class CacheManager: NSObject {
    var maps: [String] = []
    var games: [Game] = []
    let dataDir = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent(".spring")
    
    func extractAllFile(atPath path: String, withExtension fileExtension:String) -> [String] {
        let pathURL = URL(fileURLWithPath: path, isDirectory: true)
        var allFiles: [String] = []
        let fileManager = FileManager.default
        if let enumerator = fileManager.enumerator(atPath: path) {
            for file in enumerator {
                if let path = NSURL(fileURLWithPath: file as! String, relativeTo: pathURL as URL).path, path.hasSuffix(".\(fileExtension)"){
                    allFiles.append(path)
                }
            }
        }
        return allFiles
    }
    
    func loadMaps() {
//        let folderPath = Bundle.main.path(forResource: "Files", ofType: nil)
        let springMapsFileURL = dataDir.appendingPathComponent("maps")
        let maps = extractAllFile(atPath: springMapsFileURL.absoluteString, withExtension: "sd7")
        self.maps = maps
        Swift.print(maps.joined(separator: "\n"))
    }
    
    func loadMaps2() {
        let springMapsFileURL = dataDir.appendingPathComponent("maps")
        let fileManager = FileManager.default
        let enumerator = fileManager.enumerator(atPath: springMapsFileURL.absoluteString)
        while let element = enumerator?.nextObject() as? String {
            if (element.hasSuffix(".sd7")) {
                maps.append(element)
            }
        }
        Swift.print(maps)
    }
    func print(_ games: [Game]) {
        for game in games {
            for version in game.versions {
                Swift.print("\(game) \(version)")
            }
        }
    }
    func loadGames() {
        let springGamesFileURL = dataDir.appendingPathComponent("games")
        let fileManager = FileManager.default
        
        var gameFileNames: [String] = []
        
        let enumerator = fileManager.enumerator(atPath: springGamesFileURL.absoluteString)
        while let element = enumerator?.nextObject() as? String {
//            if element.hasSuffix(".sdz") || element.hasSuffix(".sdd") || element.hasSuffix(".sd7"){
                gameFileNames.append(element)
//            }
        }
        for gameFileName in gameFileNames {
            games.append(Game(name: gameFileName, ingameTime: 0, versions: [""]))
        }
        games.append(Game(name: "Balanced Annihilation", ingameTime: 0, versions: ["V9.46"]))
    }
}

struct Game {
    var name: String
    var ingameTime: Int // In Minutes
    var versions: [String]
}
