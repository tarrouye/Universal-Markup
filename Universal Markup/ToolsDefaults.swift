//
//  ToolsDefaults.swift
//  Universal Markup
//
//  Created by Théo Arrouye on 12/25/20.
//

import AppKit

struct PenType {
    let strokeWidth : Double
    let strokeColor : CGColor
}

// DEFAULT VALUES FOR TOOLS / SETTINGS
struct ToolsDefaults {
    // PEN SETTINGS
    static let penSize : Double = 5.0 // Stroke size of the drawing pen
    static let penColor : NSColor = NSColor.black // Stroke color of the drawing pen
    
    // DEFAULT PEN SETTINGS
    static let defaultPens = [
        // Black pen
        PenType(strokeWidth: 5.0, strokeColor: CGColor.black),
        
        // Yellow highlighter
        PenType(strokeWidth: 20.0, strokeColor:  CGColor(red: 1.0, green: 1.0, blue: 0, alpha: 0.5))
    ]
    
    // LINE DETECTION SETTINGS
    static let detectLines : Bool = true
    static let straightLineThreshold : CGFloat = 10.0
    
    // CAPTURE FRAME WINDOW SETTINGS
    static let bgOpacity : Double = 0.2 // Opacity of the background of the capture frame
    static let frameThickness : Double = 5.0 // Thickness of the capture frame outline
    static let winMovable : Bool = true // Whether or not the capture frame can be dragged (!canDraw)
}
