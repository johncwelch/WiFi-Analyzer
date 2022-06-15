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

//moved into contentview. That may be reversed, I haven't decided yet.

//the current*SSIDs functions replaced with functions based on getWifiInterface()
//keeping as a learning tool

/*func currentSSIDs() -> String {
		//assign var to wifi object
		let wifiClient = CWWiFiClient.shared()
		//set wifiInterface to "main/default" interface
		let wifiInteface = wifiClient.interface()
		//pull the SSID if there is one
	if let wifiSSID = wifiInteface?.ssid() {
		//return the SSID (it's a string)
		return wifiSSID
	} else {
		let wifiSSID = "no SSID"
		return wifiSSID
	}

}*/

/*func currentBSSIDs() -> String {
	//assign var to wifi object
	let wifiClient = CWWiFiClient.shared()
	//set wifiInterface to "main/default" interface
	let wifiInteface = wifiClient.interface()
	//pull the BSSID if there is one
	//note that CoreWLAN has an issue where bssid() always returns a nil
	//so this is how we do it for now. Honestly, it's a good idea anyway
	//avoids crashes
	if let wifiBSSID = wifiInteface?.bssid(){
		return wifiBSSID
	} else {
		let wifiBSSID = "no BSSID"
		return wifiBSSID
	}

}*/

//functions to get information from current interface

func getWifiInterface() -> CWInterface {
	let theWirelessClient = CWWiFiClient.shared()
	let theWirelessInterface = theWirelessClient.interface()
	return theWirelessInterface!
}

//moved this from contentview to here. Probably a better place for all this
var theWifiInterface: CWInterface = getWifiInterface()

//get ssid from theWiFiInterface
func getSSID() -> String {
	if let theSSID  = theWifiInterface.ssid() {
		return theSSID
	} else {
		let theSSID = "no SSID"
		return theSSID
	}
}

func getBSSID() -> String {
	if let theBSSID = theWifiInterface.bssid() {
		return theBSSID
	} else {
		let theBSSID = "no BSSID"
		return theBSSID
	}
}

//get channel number. That's a straight int, pretty simple. band and width
//both have multiple possible variables, we'll add them later.
func getCWChannelNumber() -> Int {
	if let wirelessChannel = theWifiInterface.wlanChannel() {
		let channelNumber = wirelessChannel.channelNumber
		return channelNumber
	} else {
		return 0
	}
}

func getRSSI() -> Int {
	//we don't need to check for nil here, you either get a valid RSSI
	//or it returns 0
	let theRSSI = theWifiInterface.rssiValue()
	return theRSSI
}

//insert PE joke here, because this function literally brings the noise
//same as with rssi, returns noise measurement or 0
func getNoise() -> Int {
	let theNoise = theWifiInterface.noiseMeasurement()
	return theNoise
}

func getTransmitRate() -> String {
	let theFormatter = NumberFormatter()
	//formatter properties
	theFormatter.numberStyle = .decimal
	theFormatter.maximumFractionDigits = 2
	//no need for nil check, returns 0 or actual rate in MBps
	let theRate = theWifiInterface.transmitRate()
	let NSNumberTransmitRate = NSNumber(value: theRate)
	let formattedTransmitRate = theFormatter.string(from: NSNumberTransmitRate)
	return formattedTransmitRate!
}

//set up SNR. We're using NumberFormatter to limit decmial places shown
func getSNR(theSig: Int, theNoise: Int) -> String {
	let theFormatter = NumberFormatter()
	//formatter properties
	theFormatter.numberStyle = .decimal
	theFormatter.maximumFractionDigits = 2
	//calculate SNR
	let signalAsFloat = Float(theSig)
	let noiseAsFloat = Float(theNoise)
	let theSNR = signalAsFloat / noiseAsFloat
	//format SNR
	//first convert to NSNumber since that's what NumberFormatteer requires
	let NSNumberSNR = NSNumber(value: theSNR)
	//convert the NSNumber version of the float to a formatted string
	let formattedSNR = theFormatter.string(from: NSNumberSNR)
	return formattedSNR!
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

