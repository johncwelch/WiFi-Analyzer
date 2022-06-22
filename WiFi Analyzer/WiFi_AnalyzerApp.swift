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
import CoreLocation

//custom class to allow for quit on closing window
//contrary to what you see in various places, you don't need to explicitly import a framework for this to work
class AppDelegate: NSObject, NSApplicationDelegate {
	func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
			return true
		}
}

@main
struct WiFi_AnalyzerApp: App {
	//implement AppDelegate custom class so we quit on closing window
	@NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
	   WindowGroup {
		   ContentView()
				//set up the min/max size
			   .frame(minWidth: 785, maxWidth: 785, minHeight: 212, maxHeight: 212)
	   }
	    //lock it down so you can't change it
	   .windowResizability(.contentSize)
    }
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

//location manager function (has to be here for some reason)
class locationDelegate: NSObject, CLLocationManagerDelegate {
	func theLocationAuthStatus(_manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		print("changed auth status: \(status.rawValue)")
		switch status.rawValue {
			case 0:
				print("Not Determined")
			case 1:
				print("Restricted")
			case 2:
				print("Denied")
			case 3:
				print("Authorized Always")
			case 4:
				print("Authorized when in use")
			default:
				print("None of the above")
		}
	}
}
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

//get and parse the auth mode, return string
func getAuthMode() -> String {
	var authModeString: String = ""
	//get the security mode from the interface
	let theSecurityMode = theWifiInterface.security()
	//test on the integer value for the mode
	switch theSecurityMode.rawValue {
		case 0:
			authModeString = "None"
		case 1:
			authModeString = "WEP"
		case 2:
			authModeString = "WPA Personal"
		case 3:
			authModeString = "WPA PersMixed"
		case 4:
			authModeString = "WPA2 Personal"
		case 5:
			authModeString = "Personal"
		case 6:
			authModeString = "Dynamic WEP"
		case 7:
			authModeString = "WPA Enterprise"
		case 8:
			authModeString = "WPA EntMixed"
		case 9:
			authModeString = "WPA2 Enterprise"
		case 10:
			authModeString = "Enterprise"
		case 11:
			authModeString = "WPA3 Personal"
		case 12:
			authModeString = "WPA3 Enterprise"
		case 13:
			authModeString = "WPA3 Transition"
		case 14:
			authModeString = "OWE"
		case 15:
			authModeString = "OWE Trans."
		default:
			authModeString = "Unknown"
	}
	return authModeString
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



