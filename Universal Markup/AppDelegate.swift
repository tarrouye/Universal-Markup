//
//  AppDelegate.swift
//  Universal Markup
//
//  Created by Théo Arrouye on 12/17/20.
//

import Cocoa
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    /* ---------------------------|
    |   DECLARE VARS              |
    |----------------------------*/
    var menuBarItem: NSStatusItem!

    var captureWindow: NSWindow!
    var toolWindow: NSWindow!
    
    var windowController: ParentWindowController!
    

    /* ---------------------------|
    |   CREATE MENU BAR ITEM      |
    |----------------------------*/
    func createMenuBarItem() {
        // get system status bar
        let statusBar = NSStatusBar.system
        
        // create a status item (menu bar item)
        menuBarItem = statusBar.statusItem(withLength: NSStatusItem.squareLength)
        // title it
        menuBarItem.button?.title = "✍️"

        // create menu to popup from menu bar item
        let statusBarMenu = NSMenu(title: "Status Bar Menu")
        menuBarItem.menu = statusBarMenu

        // add our actions to the menu
        statusBarMenu.addItem(
            withTitle: "Show all windows",
            action: #selector(AppDelegate.showAllWindows),
            keyEquivalent: "S"
        )

        statusBarMenu.addItem(
            withTitle: "Hide all windows",
            action: #selector(AppDelegate.hideAllWindows),
            keyEquivalent: "H"
        )
        
        statusBarMenu.addItem(
            withTitle: "Quit",
            action: #selector(AppDelegate.quitApplication),
            keyEquivalent: "Q"
        )
    }

    /* ---------------------------|
    |    MENU BAR ITEM ACTIONS    |
    |----------------------------*/

    @objc func showAllWindows() {
        debugPrint("Showing all windows triggered by menu bar item")
        windowController.showWindows()
    }


    @objc func hideAllWindows() {
        debugPrint("Hiding all windows triggered by menu bar item")
        windowController.hideWindows()
    }
    
    @objc func quitApplication() {
        NSApplication.shared.terminate(nil)
    }
    
    /* ---------------------------|
    |     CREATE WINDOWS          |
    |----------------------------*/
    func createWindows() {
        /* ---------------------------|
        |         TOOL VIEW           |
        |----------------------------*/
        
        // Create the SwiftUI view that provides the tool window contents.
        let toolView = ToolView()
        
        // Create the tool window and set the content view.
        toolWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 350, height: 750),
            styleMask: [.titled, .closable, .miniaturizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        
        toolWindow.isReleasedWhenClosed = false
        toolWindow.center()
        toolWindow.setFrameAutosaveName("Tool Window")
        toolWindow.contentView = NSHostingView(rootView: toolView)
        toolWindow.makeKeyAndOrderFront(nil)
        toolWindow.title = "Universal Markup"
        
        let toolWindowController = NSWindowController()
        toolWindowController.window = toolWindow
        toolWindowController.becomeFirstResponder()
        
        /* ---------------------------|
        |      CAPTURE VIEW           |
        |----------------------------*/
        
        let captureView = DrawingView()
        
        // Create the capture window and set the content view.
        captureWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.borderless, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        captureWindow.isReleasedWhenClosed = false
        captureWindow.center()
        captureWindow.setFrameAutosaveName("Main Window")
        captureWindow.contentView = captureView
        captureWindow.makeKeyAndOrderFront(nil)
        
        // Set capture window background to clear
        captureWindow.isOpaque = false
        captureWindow.backgroundColor = NSColor.clear
        captureWindow.hasShadow = false
        
        // Set window titlebar to transparent so we can color it by ignoring safe area in swiftui
        captureWindow.titlebarAppearsTransparent = true
        captureWindow.titleVisibility = .hidden
        
        // Set capture window to always be on top of other apps
        captureWindow.level = .floating
        
        // Set capture window to be draggable by background
        captureWindow.isMovableByWindowBackground = true
        
        // Set capture window movability default value to match UI
        captureWindow.isMovable = ToolsDefaults.winMovable
        
        
        // create our window controller and set toolWindow as parent and capture as child
        windowController = ParentWindowController(parent: toolWindow, children: [captureWindow])
        toolWindow.delegate = windowController
        toolWindow.becomeFirstResponder()
    }


    /* ---------------------------|
    |   NSAPPLICATIONDELEGATE     |
    |----------------------------*/
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        createWindows()
        createMenuBarItem()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        debugPrint("Application should handle reopen..")
        windowController.showWindows()
        return false
    }
}


func debugPrint(message: String) {
    #if DEBUG
        print(message)
    #endif
}
