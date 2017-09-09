//
//  AutoResizingFlowLayout.swift
//  SpringPort II
//
//  Created by MasterBel2 on 10/12/16.
//  Copyright © 2016 MasterBel2. All rights reserved.
//

import Foundation
import AppKit

class AutoResizingFlowLayout: NSCollectionViewFlowLayout {
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: NSRect) -> Bool {
        return true
    }
    
}
