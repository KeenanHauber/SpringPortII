//
//  LoginPresenter.swift
//  TASClient
//
//  Created by MasterBel2 on 17/7/18.
//  Copyright © 2018 MasterBel2. All rights reserved.
//

import Foundation

protocol LoginPresenting {
    func resetForNewLoginAttempt(_ error: String)
    func freezeDisplay()
}

final class LoginPresenter: LoginPresenting {
    
    weak var display: LoginDisplay?
    
    func resetForNewLoginAttempt(_ error: String) {
        display?.clearPassword()
        display?.display(error)
        display?.unfreeze()
    }
    
    func freezeDisplay() {
        display?.freeze()
    }
    
}
