//
//  GameCacheManager.swift
//  SpringPort II
//
//  Created by MasterBel2 on 3/2/18.
//  Copyright © 2018 MasterBel2. All rights reserved.
//

import Foundation

class GameCacheManager: GameCache {
	func has(_ game: String, versioned version: String) -> Bool {
		return false
	}
	
	var gameNames: [String] {
		get {
			return []
		}
	}
	
	func reloadGames() {
		
	}
	
//	let indexer: GameIndexer
//	let reader: IndexReader
	
	var games: [Game] = []
	
	init(_ indexer: GameIndexer) {
//		DispatchQueue.async() {
//
//		}
//		self.indexer = indexer
	}
	
//	func game(at index: Int) -> Game {
//		return Game(name: name, version: version, fileName: fileName, gameData: gameData)
//	}
	
}
