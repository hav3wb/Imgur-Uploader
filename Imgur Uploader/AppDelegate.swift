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
    
    @IBOutlet weak var statusMenu: NSMenu!
    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        let icon = NSImage(named: "statusIcon")
        //icon.setTemplate(true) // will invert icon if you use the dark theme
        
        statusItem.image = icon
        statusItem.menu = statusMenu
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    @IBAction func selectFile(sender: NSMenuItem) {
        var fileUpload = NSOpenPanel()
    }
    
    @IBAction func quitApp(sender: NSMenuItem) {
        NSApplication.sharedApplication().terminate(self)
    }

}

