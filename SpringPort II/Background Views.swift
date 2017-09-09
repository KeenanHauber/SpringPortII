//
//  Background Views.swift
//  SpringPort II
//
//  Created by MasterBel2 on 3/1/17.
//  Copyright © 2017 MasterBel2. All rights reserved.
//

import Cocoa

extension NSView {
    func blur(view: NSView!) {
        let blurView = NSView(frame: view.bounds)
        blurView.wantsLayer = true
        blurView.layer?.backgroundColor = NSColor.clear.cgColor
        blurView.layer?.masksToBounds = true
        blurView.layerUsesCoreImageFilters = true
        blurView.layer?.needsDisplayOnBoundsChange = true
        
        guard let satFilter = CIFilter(name: "CIColorControls") else {return}
        satFilter.setDefaults()
        satFilter.setValue(NSNumber(value: 1.0), forKey: "inputSaturation")
        
        guard let blurFilter = CIFilter(name: "CIGaussianBlur") else {return}
        blurFilter.setDefaults()
        blurFilter.setValue(NSNumber(value: 1.0), forKey: "inputRadius")
        
        blurView.layer?.backgroundFilters = [satFilter, blurFilter]
        
        view.addSubview(blurView, positioned: .below, relativeTo: self)
        
        blurView.layer?.needsDisplay()
    }
}

class FirstBackgroundView: NSView {
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
//        backgroundColor = NSColor.black
        backgroundColor = NSColor.black.withAlphaComponent(0.5)
    }

}

class SecondBackgroundView: NSView {
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
//        backgroundColor = NSColor.darkGray
        backgroundColor = NSColor.black.withAlphaComponent(0.5)
    }
}

class ThirdBackgroundView: NSView {
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
//        backgroundColor = NSColor.black
        backgroundColor = NSColor.black.withAlphaComponent(0.5)
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
//        blur(view: superview)
    }
}
