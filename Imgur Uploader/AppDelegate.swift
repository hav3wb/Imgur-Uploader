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
    let boundary: String = "---------------------\(arc4random())\(arc4random())"
    var apiKeys: Dictionary<String, String>?
    
    // file select panel
    let fileSelectPanel = NSOpenPanel();
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        let icon = NSImage(named: "statusIcon")!
        icon.setTemplate(true) // will invert icon if you use the dark mode
        
        statusItem.image = icon
        statusItem.menu = statusMenu
        
        // get the api keys from Configuration.plist
        let configPath = NSBundle.mainBundle().pathForResource("Configuration", ofType: "plist")
        
        if configPath != nil {
            var apiConfig = NSDictionary(contentsOfFile: configPath!) as Dictionary<String, AnyObject>
            apiKeys = apiConfig["ImgurAPI"] as? Dictionary<String, String>
        } else {
            print("ERROR: Please add API keys to Configuration.plist")
        }
        
//        let types = [NSFilenamesPboardType, NSURLPboardType]
//        statusItem.button!.registerForDraggedTypes(types)
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func uploadFile(fileUrl: NSURL) {
        let clientID = apiKeys!["ClientID"]!
        let clientSecret = apiKeys!["ClientSecret"]!
        let imageData: NSData = NSData(contentsOfURL: fileUrl, options: nil, error: nil)!
        
        let url: String = "https://api.imgur.com/3/image"
        let request: NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "POST"
        
        let requestBody = NSMutableData()
        let contentType = "multipart/form-data; boundary=\(boundary)"
        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        request.addValue("Client-ID \(clientID)", forHTTPHeaderField: "Authorization")
        
        requestBody.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        requestBody.appendData("Content-Disposition: attachment; name=\"image\"; filename=\".\(fileUrl)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        requestBody.appendData("Content-Type: application/octet-stream\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        requestBody.appendData(imageData)
        requestBody.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        requestBody.appendData("--\(boundary)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        request.HTTPBody = requestBody
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{ (response:NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if error != nil {
                NSLog(error!.localizedDescription);
            } else {
                if let responseDict: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary {
                    println("Received response: \(responseDict)")
                    if responseDict.valueForKey("status") != nil && responseDict.valueForKey("status")?.integerValue == 200 {
                        let imgLink = responseDict.valueForKey("data")!.valueForKey("link") as String
                        print("Image Uploaded:")
                        print(imgLink);
                        
                        // copy it to the clipboard
                        let pasteBoard = NSPasteboard.generalPasteboard()
                        pasteBoard.clearContents()
                        pasteBoard.writeObjects([imgLink])
                        
                        // fire a notification
                        let imgName = fileUrl.lastPathComponent
                        let notification = NSUserNotification()
                        notification.title = NSLocalizedString("Uploaded \(imgName)", comment:"")
                        notification.informativeText = NSLocalizedString("Image uploaded and copied to the clipboard: \(imgLink)", comment: "")
                        
                        NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(notification)

                    } else {
                        NSLog("An error occurred: %@", responseDict);
                    }
                } else {
                    NSLog("An error occurred - the response was invalid: %@", response)
                }
            }
        })
        
        
    }
    
//    func performDragOperation(sender: NSDraggingInfo!) {
//        println("Drag performed!")
//    }

    @IBAction func selectFile(sender: NSMenuItem) {
        fileSelectPanel.runModal()
        
        let fileUpload = fileSelectPanel.URL
        
        if fileUpload != nil {
            self.uploadFile(fileUpload!) // unwrap the NSURL
        }
    }
    
    @IBAction func quitApp(sender: NSMenuItem) {
        NSApplication.sharedApplication().terminate(self)
    }

}

