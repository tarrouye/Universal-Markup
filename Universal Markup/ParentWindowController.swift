//
//  ParentWindowController.swift
//  Universal Markup
//
//  Created by Théo Arrouye on 12/22/20.
//

import Foundation
import Cocoa

class ParentWindowController: NSObject, NSWindowDelegate {
    var parentWindow: NSWindow! // this will be the window that this delegate is assigned to
    var childWindows: [NSWindow]! // these are the windows that should be act as children
    
    // initializer to assign parent/children
    init(parent : NSWindow, children: [NSWindow]) {
        parentWindow = parent
        childWindows = children
        
        super.init()
    }
    
    // implement windowWillClose from NSWindowDelegate
    func windowWillClose(_ notification: Notification) {
        debugPrint("Parent window will close. Closing children..")
        
        // close all children
        for child in childWindows {
            debugPrint("Closing: \(child.windowNumber)")
            child.close()
        }
    }
    
    func showWindows() {
        debugPrint("Showing parent and all children")
        
        // show parent
        parentWindow.makeKeyAndOrderFront(nil)
        
        // show all children
        for child in childWindows {
            child.makeKeyAndOrderFront(nil)
        }
    }
    
    func hideWindows() {
        parentWindow.close()
    }
    
    
    @objc func undo(_ sender: Any) {
        print("undo was pressed in the edit menu")
    }
    
}
