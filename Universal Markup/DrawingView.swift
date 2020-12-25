//
//  DrawingView.swift
//  Universal Markup
//
//  Created by Théo Arrouye on 12/22/20.
//

import Foundation
import Cocoa
import SwiftUI

struct BrushStroke {
    var width : CGFloat
    var color : CGColor
    var points : [CGPoint]
}

class DrawingView: NSView {
    // declare vars
    var windowOpacity : Double = ToolsDefaults.bgOpacity
    var strokeWidth : Double = ToolsDefaults.penSize
    var strokeColor : CGColor = ToolsDefaults.penColor.cgColor
    
    var borderWidth : CGFloat = CGFloat(ToolsDefaults.frameThickness)
    //var borderColor : CGColor = CGColor(red: 0.816, green: 0.843, blue: 0.902, alpha: 1.000)
    var borderColor = CGColor.black
    
    var autoStraightenLines : Bool = ToolsDefaults.detectLines
    var straightLineThreshold : CGFloat = ToolsDefaults.straightLineThreshold
    
    
    var brushStrokes = [BrushStroke]()
    var currentStroke : Int?
    
    // initializers
    // (initialize super + register as observer to notifications)
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setWindowOpacity(notif:)), name: Notification.Name("SetWindowOpacity"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setStrokeWidth(notif:)), name: Notification.Name("SetPenSize"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setStrokeColor(notif:)), name: Notification.Name("SetPenColor"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setWindowMovable(notif:)), name: Notification.Name("SetWindowMovable"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setBorderWidth(notif:)), name: Notification.Name("SetFrameThickness"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setStraightenLines(notif:)), name: Notification.Name("SetStraightenLines"), object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // callback for SetWindowOpacity notifcation
    // sets the windowOpacity property based on passed value
    @objc func setWindowOpacity(notif: NSNotification) {
        guard let val = notif.userInfo?["value"] as? Double else {
            return
        }
        
        //debugPrint("Got notification that window opacity changed \(val) \(type(of: val))")
        
        windowOpacity = val
        if windowOpacity < 0.001 {
            windowOpacity = 0.001
        }
        
        self.needsDisplay = true
    }
    
    // callback for SetPenSize notifcation
    // sets the strokeWidth property based on passed value
    @objc func setStrokeWidth(notif: NSNotification) {
        guard let val = notif.userInfo?["value"] as? Double else {
            return
        }
        
        //debugPrint("Got notification that pen size changed \(val) \(type(of: val))")
        
        strokeWidth = val
    }
    
    // callback for SetFrameThickness notifcation
    // sets the borderWidth property based on passed value
    @objc func setBorderWidth(notif: NSNotification) {
        guard let val = notif.userInfo?["value"] as? Double else {
            return
        }
        
        //debugPrint("Got notification that pen size changed \(val) \(type(of: val))")
        
        borderWidth = CGFloat(val)
        
        self.needsDisplay = true
    }
    
    // callback for SetPenColor notifcation
    // sets the strokeColor property based on passed value
    @objc func setStrokeColor(notif: NSNotification) {
        let val = notif.userInfo?["value"] as! CGColor
        
        //debugPrint("Got notification that pen col changed \(val) \(type(of: val))")
        
        strokeColor = val
    }
    
    // callback for SetWindowMovable notifcation
    // sets the isMovable property of the window based on passed value
    @objc func setWindowMovable(notif: NSNotification) {
        guard let val = notif.userInfo?["value"] as? Bool else {
            return
        }
        
        //debugPrint("Got notification that window movable was set \(val) \(type(of: val))")
        
        self.window?.isMovable = val
    }
    
    // callback for SetStraightenLines notifcation
    // sets the isMovable property of the window based on passed value
    @objc func setStraightenLines(notif: NSNotification) {
        guard let val = notif.userInfo?["value"] as? Bool else {
            return
        }
        
        //debugPrint("Got notification that straighten lines was set \(val) \(type(of: val))")
        
        self.autoStraightenLines = val
    }
    
    func removeBrushStroke(_ id: Int) {
        brushStrokes.remove(at: id)
        print("REMOVE BRUSH STROKE")
    }
    
    func startBrushStroke(_ point: CGPoint) {
        let stroke = BrushStroke(width: CGFloat(strokeWidth), color: strokeColor, points: [point])
        brushStrokes.append(stroke)
        
        currentStroke = brushStrokes.count - 1
    }
    
    func continueBrushStroke(_ point: CGPoint) {
        guard currentStroke != nil else {
            return
        }
        brushStrokes[currentStroke!].points.append(point)
    }
    
    func endBrushStroke(_ point: CGPoint) {
        guard currentStroke != nil else {
            return
        }
        brushStrokes[currentStroke!].points.append(point)
        
        if (autoStraightenLines) {
            brushStrokes[currentStroke!] = detectAndStraightenLine(brushStrokes[currentStroke!])
        }
        
        currentStroke = nil
    }
    
    func euclid(_ p1 : CGPoint, _ p2: CGPoint) -> CGFloat {
        return sqrt(pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2))
    }
    
    func detectAndStraightenLine(_ stroke: BrushStroke) -> BrushStroke {
        // determine start and end points
        let startPoint = stroke.points[0].x < stroke.points[stroke.points.count - 1].x ? 0 : stroke.points.count - 1
        let endPoint = startPoint == 0 ? stroke.points.count - 1 : 0
        
        // determine line between start and end points
        let deltaX = stroke.points[endPoint].x - stroke.points[startPoint].x
        let deltaY = stroke.points[endPoint].y - stroke.points[startPoint].y
        
        let slope = deltaY / max(deltaX, 0.01)
        let b = stroke.points[startPoint].y - (stroke.points[startPoint].x * slope)
        // line btwn points is y = slope * x + b
        
        let slopeX = deltaX / max(deltaY, 0.01)
        let bX = stroke.points[startPoint].x - (stroke.points[startPoint].y * slopeX)
        // alternate line (for vertical lines) is x = slopeX * y + bX
        
        // check if stroke falls within threshold of this line
        var projLine = BrushStroke(width: stroke.width, color: stroke.color, points: stroke.points)
        
        for i in stride(from: startPoint, to: endPoint, by: (startPoint < endPoint) ? 1 : -1) {
            // get proj point
            if (deltaX > deltaY) {
                projLine.points[i].y = slope * stroke.points[i].x + b
            } else {
                projLine.points[i].x = slopeX * stroke.points[i].y + bX
            }
            
            // check threshold
            if euclid(projLine.points[i], stroke.points[i]) > straightLineThreshold {
                // this is not a straight line, so return it as is
                debugPrint("failed threshold test: \(abs(projLine.points[i].y - stroke.points[i].y))")
                debugPrint(projLine.points)
                debugPrint(stroke.points)
                return stroke
            }
        }
        
        // if we got to here, a line was detected so fix it and return it
        debugPrint((deltaX > deltaY) ? "mended line (y points)" : "mended line (x points)")
        return projLine
    }
    
    override func mouseDown(with event: NSEvent) {
        if (!self.window!.isMovable) { // don't draw if they would be dragging the panel
            startBrushStroke(event.locationInWindow)
            
            self.needsDisplay = true
        }
    }
    
    override func mouseDragged(with event: NSEvent) {
        continueBrushStroke(event.locationInWindow)
        
        self.needsDisplay = true
    }
    
    override func mouseUp(with event: NSEvent) {
        endBrushStroke(event.locationInWindow)
        
        self.needsDisplay = true
    }
    
    override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        return true
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        guard let context = NSGraphicsContext.current?.cgContext else{
           return
        }
        
        // background w/ variable opacity (fill) + window frame (stroke)
        context.setFillColor(CGColor(red: 1, green: 1, blue: 1, alpha: CGFloat(windowOpacity)))
        context.fill(bounds)
        context.setStrokeColor(borderColor)
        context.setLineWidth(borderWidth)
        context.setFillColor(CGColor.clear)
        context.stroke(bounds.insetBy(dx: borderWidth / 2, dy: borderWidth / 2))
        
        
        // draw brush strokes
        for stroke in brushStrokes {
            // set the stroke width
            context.setLineWidth(stroke.width)
            context.setLineCap(.round)
            
            // begin path
            context.beginPath()
            
            // go through stroke points to create path
            if (stroke.points.count > 2) {
                context.move(to: stroke.points[0])
                for i in 1...stroke.points.count - 1 {
                    context.addLine(to: stroke.points[i])
                }
            } else if (stroke.points.count == 2) {
                context.move(to: stroke.points[0])
                context.addLine(to: stroke.points[1])
            } else {
                continue
            }
            
            // set color and draw the stroke
            context.setStrokeColor(stroke.color)
            context.strokePath()
        }
        
    }
}
