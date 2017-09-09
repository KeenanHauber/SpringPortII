//
//  Replay.swift
//  SpringPort II
//
//  Created by MasterBel2 on 28/3/17.
//  Copyright © 2017 MasterBel2. All rights reserved.
//

import Foundation

struct Replay {
    let fileName: String
    let date: String
    let map: String
    let fileExtension: String
    let engineVersion: String
    
    init() {// This initialiser assumes that the map name has no underscores.
            // That will not always be the case. Please change it so that 
            // it can grab the data from inside the file. This first init()
            // will end up being obsolete anyway. The second one you really
            // have to worry about, though.
        fileName = "Date_160627_Name Of Map_103.sdfz"
        let array = fileName.components(separatedBy: "_")
        self.date = array[0]
        self.map = array[2]
        let array2 = array[3].components(separatedBy: ".")
        self.engineVersion = array2[0]
        self.fileExtension = array2[1]
    }
    
    init(with data: NSData, from fileName: String) {
        let string = String(describing: data)
        self.fileName = fileName
        let array = fileName.components(separatedBy: "_")
        self.date = array[0] 
        self.map = array[2]
        let array2 = array[3].components(separatedBy: ".")
        self.engineVersion = array2[0]
        self.fileExtension = array2[1]
        
        
        // I know this is a copout, but that's how it'll be for now. Okay? Good.
    }
}
