//
//  WiFi_AnalyzerApp.swift
//  WiFi Analyzer
//
//  Created by John Welch on 6/9/22.
//

import SwiftUI
//needed to get wifi info
import CoreWLAN
//import UniformTypeIdentifiers
import Cocoa

//custom class to allow for quit on closing window
//contrary to what you see in various places, you don't need to explicitly import a framework for this to work
class AppDelegate: NSObject, NSApplicationDelegate {
	func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
			return true
		}
	/*func applicationDidFinishLaunching(_ notification: Notification) {
		let window = NSWindow(
			contentRect: NSRect(x: 0, y: 0, width: 785, height: 212),
			styleMask: [.titled, .closable, .miniaturizable],
			backing: .buffered, defer: false)
		window.center()
	}*/
}

//timer go here?

//this will eventually return more
func currentSSIDs() -> String {
		//assign var to wifi object
		let wifiClient = CWWiFiClient.shared()
		//set wifiInterface to "main/default" interface
		let wifiInteface = wifiClient.interface()
		//pull the SSID if there is one
		let wifiSSID = wifiInteface?.ssid()
		//return the SSID (it's a string)
		return wifiSSID!
}

//get the time in hh:mm:ss, return as sstring
//doesn't seem to be needed, may remove.
func getCurrentTime() -> String {
	//create date formatter object
	let dateFormatter = DateFormatter()
	//by only setting the time style, we just get the time when we return it
	//medium gives us the format we want
	dateFormatter.timeStyle = .medium
	//this automatically pulls just the time from the current data & time
	//as a string
	let theTime = dateFormatter.string(from: Date())
	//return the string
	return theTime
}

//keeping for syntax examples
/*var timeFormatter : DateFormatter {
	let timeFormat = DateFormatter()
	timeFormat.timeStyle = .medium
	return timeFormat
}*/

//save panel function for creating new save file
func showSavePanel() -> URL? {
	let savePanel = NSSavePanel()
	//you have to use this moving forward instead of filetypes
	//you have to use a . in front of the UTType identifier
	savePanel.allowedContentTypes = [.text,.commaSeparatedText]
	//have the "New Folder" button
	savePanel.canCreateDirectories = true
	//Don't hide extensions
	savePanel.isExtensionHidden = false
	//don't allow saving to other file types
	savePanel.allowsOtherFileTypes = false
	//various UI messages
	savePanel.title = "Save your data file"
	savePanel.message = "Chose a location and file for your wifi data"
	savePanel.nameFieldLabel = "File name:"
	//run as floating dialong instead of sheet
	let response = savePanel.runModal()
	//return the response
	return response == .OK ? savePanel.url : nil
}

@main
struct WiFi_AnalyzerApp: App {
	//implement AppDelegate custom class so we quit on closing window
	@NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

    }
}

