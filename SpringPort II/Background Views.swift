//
//  Background Views.swift
//  SpringPort II
//
//  Created by MasterBel2 on 3/1/17.
//  Copyright © 2017 MasterBel2. All rights reserved.
//

import Cocoa

class FirstBackgroundView: NSView {
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        backgroundColor = NSColor.black
    }
}

class SecondBackgroundView: NSView {
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
//        backgroundColor = NSColor.darkGray
        backgroundColor = NSColor.black
    }
}

class ThirdBackgroundView: NSView {
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        backgroundColor = NSColor.black
    }
}

class AlternateThirdBackgroundView: NSView {
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        backgroundColor = NSColor.init(red: 150, green: 150, blue: 150)
    }
}

class BlurView: NSView {
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        backgroundColor = NSColor.black.withAlphaComponent(0.5)
//        backgroundColor = NSColor.black
    }
}
