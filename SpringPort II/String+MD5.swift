//
//  String+MD5.swift
//  OSXSpringLobby
//
//  Created by Belmakor on 30/06/2016.
//  Copyright © 2016 MasterBel2. All rights reserved.
//

import Cocoa

extension String {
    
    func md5() -> Data? {
        guard let data = data(using: String.Encoding.utf8) else { return nil }
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5((data as NSData).bytes, CC_LONG(data.count), &digest)
        return Data(bytes: digest)
    }
    
}
