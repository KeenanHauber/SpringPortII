//
//  NSData+Base64.swift
//  OSXSpringLobby
//
//  Created by Belmakor on 30/06/2016.
//  Copyright © 2016 MasterBel2. All rights reserved.
//

import Foundation

extension Data {

    func base64Encoded() -> String {
        return base64EncodedString(options: [])
    }
    
}
