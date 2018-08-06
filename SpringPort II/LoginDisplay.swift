//
//  LoginDisplay.swift
//  TASClient
//
//  Created by MasterBel2 on 17/7/18.
//  Copyright © 2018 MasterBel2. All rights reserved.
//

import Foundation
protocol LoginDisplay: class {
    func freeze()
    func unfreeze()
    func display(_ errorString: String)
    func clearPassword()
    func clearUsername()
}
