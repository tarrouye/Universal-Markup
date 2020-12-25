//
//  WindowManager.swift
//  Universal Markup
//
//  Created by Théo Arrouye on 12/22/20.
//

import Foundation

// Struct to contain CGWindow Info
struct WindowInfo {
    var id: Int
    var info: [String : Any]
}

extension WindowInfo: Comparable {
    static func < (lhs: WindowInfo, rhs: WindowInfo) -> Bool {
        return lhs.id < rhs.id
    }
    
    static func == (lhs: WindowInfo, rhs: WindowInfo) -> Bool {
        return lhs.id == rhs.id
    }
}

// WindowManager: Manages a list of active CGWindows
struct WindowManager {
    var windowList : [WindowInfo]
    
    init() {
        // initialize empty windowList
        windowList = [WindowInfo]()
    }
    
    mutating func populateWindowList() {
        // try to populate it
        if let info = CGWindowListCopyWindowInfo(.optionOnScreenOnly, kCGNullWindowID) as? [[ String : Any]] {
            
            for dict in info {
                print(dict)
                
                windowList.append(WindowInfo(id: dict["kCGWindowNumber"] as! Int, info: dict))
            }
        }
    
        
        windowList = windowList.sorted()
    }
}
