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
    
    // file select panel
    let fileSelectPanel = NSOpenPanel();
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        let icon = NSImage(named: "statusIcon")!
        icon.setTemplate(true) // will invert icon if you use the dark mode
        
        statusItem.image = icon
        statusItem.menu = statusMenu
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func uploadFile(fileUrl: NSURL) {
        print(fileUrl)
    }

    @IBAction func selectFile(sender: NSMenuItem) {
        fileSelectPanel.runModal()
        
        var fileUpload = fileSelectPanel.URL
        
        if (fileUpload != nil) {
            self.uploadFile(fileUpload!) // unwrap the NSURL
        }
    }
    
    @IBAction func quitApp(sender: NSMenuItem) {
        NSApplication.sharedApplication().terminate(self)
    }

}

