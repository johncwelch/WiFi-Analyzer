//
//  WiFi_AnalyzerApp.swift
//  WiFi Analyzer
//
//  Created by John Welch on 6/9/22.
//

import SwiftUI
//needed to get wifi info
import CoreWLAN


//custom class to allow for quit on closing window
//contrary to what you see in various places, you don't need to explicitly import a framework for this to work
class AppDelegate: NSObject, NSApplicationDelegate {
	func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
			return true
		}
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

