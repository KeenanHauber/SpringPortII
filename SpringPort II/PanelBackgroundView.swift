//
//  PanelBackgroundView.swift
//  SpringPort II
//
//  Created by MasterBel2 on 3/1/17.
//  Copyright © 2017 MasterBel2. All rights reserved.
//

import Cocoa

class PanelBackgroundView: NSView {
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        drawPanelBackground()
        drawTriangles()
    }
    func drawPanelBackground() {
        let color: NSColor = NSColor.black
        let padding: CGFloat = 5.0
        let gradient = NSGradient(colors: [NSColor.darkGray, NSColor.lightGray, NSColor.darkGray])
        let cornerRadius: CGFloat = 8.0
        let drawingBounds = CGRect(x: -10, y: 0, width: 259, height: 413)
        let frame = drawingBounds.insetBy(dx: padding, dy: padding)
        
        let shadow = NSShadow()
        shadow.shadowOffset = NSSize(width: 2, height: -2)
        shadow.shadowBlurRadius = (4)
        shadow.set()
        
        color.set()
        
        NSBezierPath(roundedRect: frame, xRadius: cornerRadius, yRadius: cornerRadius).fill()
        
    }
    func drawTriangles() {
        
    }
    
}
