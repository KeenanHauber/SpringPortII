//
//  CacheManager.swift
//  SpringPort II
//
//  Created by MasterBel2 on 7/1/17.
//  Copyright © 2017 MasterBel2. All rights reserved.
//

import Cocoa

struct Map {
	let name: String
	let checksum: UInt32
	let fileName: String
	var mapData: MapData?
}

struct Game {
	let name: String
	let fileName: String
	var gameData: GameData?
}

struct Side {
	let name: String
	let icon: NSImage
}

struct GameData {
	let checksum: UInt32
	let sides: [Side]
}

protocol MapDataSource {
	var mapCount: Int { get }
	func map(at index: Int) -> Map
}

protocol GameDataSource {
	var gameCount: Int { get }
	func game(at index: Int) -> Game
}

protocol Cache: class {
	func autodetectSpringVersions()
	
	var engineVersions: [String] { get }
	var mapNames: [String] { get }
	var gameNames: [String] { get }
	
	func has(_ engine: String) -> Bool
	func hasMap(with checksum: UInt32) -> Bool
	func has(game: String, versioned version: String) -> Bool
}

class CacheManager: Cache {
	func autodetectSpringVersions() {
		let fileManager = FileManager.default
		let allApplicationURLs =
			fileManager.urls(for: .allApplicationsDirectory, in: .localDomainMask)
				.reduce([], { (result, url) -> [URL] in
					let urls = try? fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
					return result + (urls ?? [])
				})
		for applicationURL in allApplicationURLs {
			let config = UnitsyncConfig(appURL: applicationURL)
			if let wrapper = UnitsyncWrapper(config: config) {
				let version = wrapper.springVersion
				engines.append(EngineData(version: version, url: applicationURL, unitsyncWrapper: wrapper))
				//				wrapper.performBlock {
				//					print("Available Spring version: \(wrapper.springVersion) (at \(applicationURL.path))")
				//				}
			}
		}
	}
	
	// ENGINE
	
	private var engines: [EngineData] = []
	var engineVersions: [String] {
		get {
			var temp: [String] = []
			for engine in engines {
				temp.append(engine.version)
			}
			return temp
		}
	}
	func has(_ engine: String) -> Bool {
		for storedEngine in engineVersions {
			if storedEngine == engine || "\(storedEngine).0" == engine {
				return true
			}
		}
		return false
	}
	
	// MAPS
	
	private var maps: [Map] = []
	var mapNames: [String] {
		get {
			var temp: [String] = []
			for map in maps {
				temp.append(map.name)
			}
			return temp
		}
	}
	func hasMap(with checksum: UInt32) -> Bool {
		for map in maps {
			if map.checksum == checksum {
				return true
			}
		}
		return false
	}
	
	// GAMES
	
	private var games: [Game] = []
	var gameNames: [String] {
		get {
			var temp: [String] = []
			for game in games {
				temp.append(game.name)
			}
			return temp
		}
	}
	func has(game: String, versioned version: String) -> Bool {
		return false // TODO: -- Fix
	}
}
