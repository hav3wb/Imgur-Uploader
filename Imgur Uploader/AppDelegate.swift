//
//  AppDelegate.swift
//  Imgur Uploader
//
//  Created by Nelson Pecora on 10/26/14.
//  Copyright (c) 2014 Nelson Pecora. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var statusBar = NSStatusBar.systemStatusBar()
    var statusBarItem : NSStatusItem = NSStatusItem()
    var menu: NSMenu = NSMenu()
    var menuItem : NSMenuItem = NSMenuItem()
    
    // status bar images
    var imgurIcon = NSImage.init?(byReferencingFile "images.xcassets": String)
    
    override func awakeFromNib() {
        //Add statusBarItem
        statusBarItem = statusBar.statusItemWithLength(-1)
        statusBarItem.menu = menu
        statusBarItem.title = "Presses"
        statusBarItem.image =
        
        //Add menuItem to menu
        menuItem.title = "Select Image"
        menuItem.action = Selector("setWindowVisible:")
        menuItem.keyEquivalent = ""
        menu.addItem(menuItem)
    }

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

