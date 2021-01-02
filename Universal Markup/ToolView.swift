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
    
    @State var hoveringCaptureButton: Bool = false
    
    @State var captureNotClear: Bool = true
    
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
        NotificationCenter.default.post(name: Notification.Name("SetPenColor"), object: nil, userInfo: ["value" : penColor.cgColor!])
    }
    
    func winPickerChanged() {
        NotificationCenter.default.post(name: Notification.Name("SetWindowMovable"), object: nil, userInfo: ["value" : winMovable])
    }
    
    func detectLinesChanged() {
        NotificationCenter.default.post(name: Notification.Name("SetStraightenLines"), object: nil, userInfo: ["value" : detectLines])
    }
    
    func selectedDefaultPen(_ pen: Int) {
        NotificationCenter.default.post(name: Notification.Name("SelectedDefaultPen"), object: nil, userInfo: ["value" : pen])
        
        
        penColor = Color(ToolsDefaults.defaultPens[pen].strokeColor)
        penSize = ToolsDefaults.defaultPens[pen].strokeWidth
    }
    
    func captureButtonClicked() {
        if self.captureNotClear {
            NotificationCenter.default.post(name: Notification.Name("CaptureButtonClicked"), object: nil, userInfo: nil)
            self.winMovable = true
            winPickerChanged()
        } else  {
            NotificationCenter.default.post(name: Notification.Name("ClearButtonClicked"), object: nil, userInfo: nil)
        }
        
        self.captureNotClear = !self.captureNotClear
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if (self.captureNotClear) {
                // [GROUP] ALL CAPTURE CONTROLS
                Group {
                    // [GROUP] CAPTURE FRAME CONTROLS
                    Group {
                        Text("Capture Frame Controls")
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding(.bottom)
                        
                        // Background Opacity Slider
                        VStack(alignment: .leading) {
                            Text("Background Opacity")
                            
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
                            
                            Slider(value: Binding(get: {
                                self.frameThickness
                            }, set: { (newVal) in
                                self.frameThickness = newVal
                                self.frameThicknessChanged()
                            }), in: 1...20, step: 0.1)
                        }
                        .frame(maxWidth: 300)
                        .padding(.bottom)
                        
                        // Window Movability Toggle
                        HStack {
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
                            
                            
                            Divider()
                            Spacer()
                            
                            Text("Inking \(winMovable ? "Disabled" : "Enabled")")
                                .fontWeight(.bold)
                        }
                        
                        Text("Note: Inking is Enabled/Disabled based on the selected value for Frame Dragging.")
                            .font(.caption)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    Divider()
                    
                    // [GROUP] PEN CONTROLS
                    Group {
                        Text("Pen Controls")
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding(.bottom)
                        
                        // Stroke Width Slider
                        VStack(alignment: .leading) {
                            Text("Stroke Width")
                            
                            Slider(value: $penSize, in: 1...50, step: 0.1, onEditingChanged: { editing in
                                if (!editing) {
                                    self.penSizeChanged()
                                }
                            })
                        }
                        .frame(maxWidth: 300)
                        .padding(.bottom)
                        
                        // Stroke color picker
                        ColorPicker("Stroke Color", selection: Binding(get: {
                            self.penColor
                        }, set: { (newVal) in
                            self.penColor = newVal
                            self.penColorChanged()
                        }), supportsOpacity: true)
                        
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
                        
                        
                        // Default pen options
                        VStack(alignment: .leading) {
                            Text("Templates")
                                .font(.headline)
                            
                            HStack {
                                // Pen button
                                Button(action: {
                                    selectedDefaultPen(0)
                                }) {
                                    Text("Pen")
                                }
                                
                                // Highlighter button
                                Button(action: {
                                    selectedDefaultPen(1)
                                }) {
                                    Text("Highlighter")
                                }
                            }
                        }
                    }
                    
                    Divider()
                }
            } else {
                EmptyView()
            }
            
            HStack {
                Spacer()
            
                // Capture button
                Text(captureNotClear ? "Capture" : "Clear")
                    .padding()
                    .background(hoveringCaptureButton ? Color(red: 0.0, green: 0.5, blue: 1.0, opacity: 0.75) : (captureNotClear ? Color.blue : Color.red))
                    .foregroundColor(Color.white)
                    .font(.title2)
                    .cornerRadius(100)
                    .padding(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 100)
                            .stroke(hoveringCaptureButton ? Color(red: 0.0, green: 0.5, blue: 1.0, opacity: 0.75) : (captureNotClear ? Color.blue : Color.red), lineWidth: 5)
                    )
                    .onTapGesture {
                        captureButtonClicked()
                    }
                    .onHover { isHovered in
                        self.hoveringCaptureButton = isHovered
                    }
                
                Spacer()
            }
            .padding()
            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ToolView_Previews: PreviewProvider {
    static var previews: some View {
        ToolView()
    }
}
