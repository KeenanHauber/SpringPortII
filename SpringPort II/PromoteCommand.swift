//
//  PromoteCommand.swift
//  SpringPort II
//
//  Created by MasterBel2 on 2/1/18.
//  Copyright © 2018 MasterBel2. All rights reserved.
//

import Foundation

struct PromoteCommand: ServerCommand {
	let battleId: String
	var description: String {
		print("PROMOTE \(battleId)")
		return "PROMOTE \(battleId)"
	}
}
