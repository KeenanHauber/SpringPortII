//
//  CacheManager.swift
//  SpringPort II
//
//  Created by MasterBel2 on 7/1/17.
//  Copyright © 2017 MasterBel2. All rights reserved.
//

import Cocoa

class Map {
	let name: String
	let checksum: Int32
	let fileName: String
	let index: Int // this won't necessarily work if additional maps are added to the DIR. Please test.
	
	var mapData: MapData?
	init(identification: (String, Int32, String, Int)) {
		self.name = identification.0
		self.checksum = identification.1
		self.fileName = identification.2
		self.index = identification.3
	}
	init(name: String, checksum: Int32, fileName: String, index: Int, mapData: MapData) {
		self.name = name
		self.checksum = checksum
		self.fileName = fileName
		self.mapData = mapData
		self.index = index
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
	let checksum: Int32
	let sides: [Side]
}

protocol MapDataSource {
	var mapCount: Int { get }
	func mapData(for map: Map) -> MapData
	func mapIdentification(at index: Int) -> (String, Int32, String, Int)
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
	func hasMap(with checksum: Int32) -> Bool
	func has(_ game: String, versioned version: String) -> Bool
	
	func minimap(for mapChecksum: Int32) -> NSImage
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
	func hasMap(with checksum: Int32) -> Bool {
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
	func minimap(for mapChecksum: Int32) -> NSImage {
		guard let engine = latestEngine else { debugPrint("Non-Fatal Error: No engines, cannot load minimap"); return #imageLiteral(resourceName: "Caution") }
		guard let unitsync = engine.unitsyncWrapper else { debugPrint("No unitsync wrapper to detect games"); return #imageLiteral(resourceName: "Caution") }
		
		let matches = maps.filter { $0.checksum == mapChecksum }
		guard matches.count == 1 else { return #imageLiteral(resourceName: "Caution") }
		let map = matches[0]
		
		let mapData: MapData = map.mapData ?? unitsync.mapData(for: map)
		
		guard let image = NSImage(rgb565Pixels: mapData.miniMapData, width: 1024, height: 1024) else { debugPrint("Non-Fatal Error: Could not create NSImage from miniMapData"); return #imageLiteral(resourceName: "Caution") }
		
		image.size = CGSize(width: mapData.mapWidth, height: mapData.mapHeight)
		
		return image
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
