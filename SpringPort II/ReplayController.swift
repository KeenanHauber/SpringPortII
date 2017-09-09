//
//  ReplayController.swift
//  SpringPort II
//
//  Created by MasterBel2 on 28/3/17.
//  Copyright © 2017 MasterBel2. All rights reserved.
//

import Foundation

protocol ReplayControllerDelegate: class {
    func launch(_ replay: Replay)
}

class ReplayController {
    var replays: [Replay] = []
    
    weak var delegate: ReplayControllerDelegate?
}
