//
//  IndexParser.swift
//  SpringPort II
//
//  Created by MasterBel2 on 3/2/18.
//  Copyright © 2018 MasterBel2. All rights reserved.
//

import Foundation

protocol IndexParser {
	func storedMaps() -> [Map]
	func storedData(for: Map) -> MapData?
	
	func storedGames() -> [Game]
	func storedData(for: Game) -> GameData?
}

class IndexParserObject: IndexParser {
	let fileManager = FileManager.default
	
	
	func storedMaps() -> [Map] {
		return []
	}
	
	func storedData(for: Map) -> MapData? {
		return nil
	}
	
	func storedGames() -> [Game] {
		return []
	}
	
	func storedData(for: Game) -> GameData? {
		return nil
	}
	
}
