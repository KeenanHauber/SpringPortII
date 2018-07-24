//
//  LoginDisplay.swift
//  TASClient
//
//  Created by Keenan Hauber on 17/7/18.
//  Copyright © 2018 Keenan Hauber. All rights reserved.
//

import Foundation
protocol LoginDisplay: class {
    func freeze()
    func unfreeze()
    func display(_ errorString: String)
    func clearPassword()
    func clearUsername()
}
