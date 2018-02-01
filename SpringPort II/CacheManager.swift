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
	init(identification: (String, UInt32, String)) {
		self.name = identification.0
		self.checksum = identification.1
		self.fileName = identification.2
	}
	init(name: String, checksum: UInt32, fileName: String, mapData: MapData) {
		self.name = name
		self.checksum = checksum
		self.fileName = fileName
		self.mapData = mapData
	}
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
	func setup()
	func reloadGames()
	func reloadMaps()
	func reloadEngines()
	
	var engineVersions: [String] { get }
	var mapNames: [String] { get }
	var gameNames: [String] { get }
	
	func has(_ engine: String) -> Bool
	func hasMap(with checksum: UInt32) -> Bool
	func has(_ game: String, versioned version: String) -> Bool
}

class CacheManager: Cache {
	func setup() {
		autodetectSpringVersions()
		loadMaps()
		loadGames()
	}
	
	private func autodetectSpringVersions() {
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
				wrapper.performBlockAndWait {
					let version = wrapper.springVersion
					engines.append(EngineData(version: version, url: applicationURL, unitsyncWrapper: wrapper))
				}
			}
		}
	}
	
	// ENGINE
	
	private var engines: [EngineData] = []
	private var latestEngine: EngineData? {
		get {
			let sortedVersions = self.engines.sorted { $0.version > $1.version }
			return sortedVersions.first
		}
	}
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
	func reloadEngines() {
		engines = []
		autodetectSpringVersions()
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
	private func loadMaps() {
		guard let engine = latestEngine else { debugPrint("Non-Fatal Error: No engines, cannot load maps"); return }
		guard let unitsync = engine.unitsyncWrapper else { debugPrint("No unitsync wrapper to detect games"); return }
		for index in 0..<unitsync.mapCount {
			let map = Map(identification: unitsync.mapIdentification(at: index))
			maps.append(map)
		}
	}
	func reloadMaps() {
		maps = []
		loadMaps()
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
	func has(_ game: String, versioned version: String) -> Bool {
		return false // TODO: -- Fix
	}
	private func loadGames() {
		guard let engine = latestEngine else { debugPrint("Non-Fatal Error: No engines, cannot load games"); return }
		guard let unitsync = engine.unitsyncWrapper else { debugPrint("No unitsync wrapper to detect games"); return }
		// TODO: -- loadGames() does nothing atm
	}
	func reloadGames() {
		games = []
		loadGames()
	}
}
