//
//  ToolView.swift
//  Universal Markup
//
//  Created by Théo Arrouye on 12/22/20.
//

import SwiftUI

struct ToolView: View {
    // Initialize state with default values of tools
    @State var bgOpacity = ToolsDefaults.bgOpacity
    @State var penSize = ToolsDefaults.penSize
    @State var frameThickness = ToolsDefaults.frameThickness
    @State var penColor = Color(ToolsDefaults.penColor)
    @State var winMovable = ToolsDefaults.winMovable
    @State var detectLines = ToolsDefaults.detectLines
    
    func bgOpacityChanged() {
        NotificationCenter.default.post(name: Notification.Name("SetWindowOpacity"), object: nil, userInfo: ["value" : bgOpacity])
    }
    
    func frameThicknessChanged() {
        NotificationCenter.default.post(name: Notification.Name("SetFrameThickness"), object: nil, userInfo: ["value" : frameThickness])
    }
    
    func penSizeChanged() {
        NotificationCenter.default.post(name: Notification.Name("SetPenSize"), object: nil, userInfo: ["value" : penSize])
    }
    
    func penColorChanged() {
        if #available(OSX 11, *) {
            NotificationCenter.default.post(name: Notification.Name("SetPenColor"), object: nil, userInfo: ["value" : penColor.cgColor!])
        } else {
            // Fallback on earlier versions
        }
    }
    
    func winPickerChanged() {
        NotificationCenter.default.post(name: Notification.Name("SetWindowMovable"), object: nil, userInfo: ["value" : winMovable])
    }
    
    func detectLinesChanged() {
        NotificationCenter.default.post(name: Notification.Name("SetStraightenLines"), object: nil, userInfo: ["value" : detectLines])
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Controls")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.bottom)
            
            // Background Opacity Slider
            VStack(alignment: .leading) {
                Text("Background Opacity")
                    .font(.headline)
                
                Slider(value: Binding(get: {
                    self.bgOpacity
                }, set: { (newVal) in
                    self.bgOpacity = newVal
                    self.bgOpacityChanged()
                }), in: 0...1, step: 0.1)
            }
            .frame(maxWidth: 300)
            .padding(.bottom)
            
            // Frame Width Slider
            VStack(alignment: .leading) {
                Text("Frame Width")
                    .font(.headline)
                
                Slider(value: Binding(get: {
                    self.frameThickness
                }, set: { (newVal) in
                    self.frameThickness = newVal
                    self.frameThicknessChanged()
                }), in: 1...20, step: 0.1)
            }
            .frame(maxWidth: 300)
            .padding(.bottom)
            
            // Stroke Width Slider
            VStack(alignment: .leading) {
                Text("Stroke Width")
                    .font(.headline)
                
                Slider(value: $penSize, in: 1...20, step: 0.1, onEditingChanged: { editing in
                    if (!editing) {
                        self.penSizeChanged()
                    }
                })
            }
            .frame(maxWidth: 300)
            .padding(.bottom)
            
            // Stroke color picker
            if #available(OSX 11.0, *) {
                ColorPicker("Stroke Color", selection: Binding(get: {
                    self.penColor
                }, set: { (newVal) in
                    self.penColor = newVal
                    self.penColorChanged()
                }), supportsOpacity: true)
            } else {
                // Fallback on earlier versions
            }
            
            // Line Detection Toggle
            Picker(selection: Binding(get: {
                self.detectLines
            }, set: { (newVal) in
                self.detectLines = newVal
                self.detectLinesChanged()
            }), label: Text("Auto-Straighten Lines:")) {
                Text("Enabled").tag(true)
                Text("Disabled").tag(false)
            }.pickerStyle(RadioGroupPickerStyle())
            .padding(.bottom)
            
            // Window Movability Toggle
            Picker(selection: Binding(get: {
                self.winMovable
            }, set: { (newVal) in
                self.winMovable = newVal
                self.winPickerChanged()
            }), label: Text("Frame Dragging:")) {
                Text("Enabled").tag(true)
                Text("Disabled").tag(false)
            }.pickerStyle(RadioGroupPickerStyle())
            .padding(.bottom)
            
            
            // Capture button
            Button(action: {
                debugPrint("Capture button clicked!")
            }) {
                Text("Capture")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ToolView_Previews: PreviewProvider {
    static var previews: some View {
        ToolView()
    }
}
