//
//  GameIndexer.swift
//  SpringPort II
//
//  Created by MasterBel2 on 3/2/18.
//  Copyright © 2018 MasterBel2. All rights reserved.
//

import Foundation

protocol GameIndexer {
	func updateIndex()
}

class GameIndexerObject: GameIndexer { // Purpose of the class is to index games
	let fileManager = FileManager.default
	let springDataDir = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent(".spring")
	
	//	func retrieveGame(at index: Int) -> Game {
//
//	}
	
	func updateIndex() {
		do {
			let indexParser: IndexParser = IndexParserObject()
			let downloadedGames = try fileManager.contentsOfDirectory(atPath: springDataDir.absoluteString)
			let storedGames = indexParser.storedGames()
			for game in storedGames {
				var downloaded = false
				for downloadedGame in downloadedGames {
					if downloadedGame == game.fileName {
						downloaded = true
					}
				}
				if downloaded == false {
					removeIndexing(of: game.name, version: game.version)
				}
			}
			for downloadedGame in downloadedGames {
				var indexed = false
				for game in storedGames {
					if downloadedGame == game.fileName {
						indexed = true
					}
				}
				if indexed == false {
					index(downloadedGame)
				}
			}
		} catch {
			debugPrint("Non-Fatal Error: Could not access ~/.spring/games")
		}
	}
	private func removeIndexing(of game: String, version: String) {
		
	}
	
	private func index(_ gameFile: String) {
		
	}
}

protocol GameInfoParser {
	func parse(_ info: String) -> String
}

class GameInfoParserObject {
	
}
