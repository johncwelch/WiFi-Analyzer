//
//  ContentView.swift
//  WiFi Analyzer
//
//  Created by John Welch on 6/9/22.
//

import SwiftUI

struct ContentView: View {
	//SSID value
	@State private var currentSSID: String = ""
	//current WAP MAC
	@State private var currentWAPMAC: String = ""
	//current WiFI channel
	@State private var currentChannel: String = ""
	//signal strength in dbm
	@State private var signalStrength: Int = 0
	//signal noise in dbm
	@State private var signalNoise: Int = 0
	//SNR in dbm
	@State private var signalToNoise: Int = 0
	//data rate in Mbps
	@State private var dataRate: Double = 0.0
	//current time
	@State private var theCurrentTime: String = ""

	//checkbox state
	@State private var writeToFile = false

	//Timer setup
	@State private var theTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	//timer on/off var
	@State private var timerState: Bool = false

    var body: some View {
	    VStack(alignment: .leading) {
		    HStack(alignment: .top) {
			    VStack(alignment: .leading) {
				    Text("SSID:")
					    .font(.body)
					    .fontWeight(.semibold)
					    .padding(.leading, 20.0)
					    .frame(width: 115.0,height: 22.0,alignment: .leading)
					    .textSelection(.enabled)
					    .accessibilityLabel("SSID Label")
					    .accessibilityIdentifier("ssidLabel")
				    Text("WAP MAC:")
					    .font(.body)
					    .fontWeight(.semibold)
					    .padding(.leading, 20.0)
					    .frame(width: 115.0,height: 22.0,alignment: .leading)
					    .textSelection(.enabled)
					    .accessibilityLabel("WAP MAC Label")
					    .accessibilityIdentifier("wapMACLabel")
				    Text("Channel:")
					    .font(.body)
					    .fontWeight(.semibold)
					    .padding(.leading, 20.0)
					    .frame(width: 115.0,height: 22.0,alignment: .leading)
					    .textSelection(.enabled)
					    .accessibilityLabel("Wireless Channel Label")
					    .accessibilityIdentifier("wirelessChannelLabel")
				    Toggle(isOn: $writeToFile) {
					    Text("Write To File")
				    }
				    .padding([.top, .leading], 20.0)
			    }
			    .frame(width: 115.0)
			    VStack(alignment: .leading) {
				    Text("\(currentSSID)")
					    .fontWeight(.regular)
					    .frame(width: 162.0,height: 22.0,alignment: .leading)
					    .textSelection(.enabled)
					    .accessibilityLabel("Name of current WiFi network")
					    .accessibilityIdentifier("ssidName")
				    Text("\(currentWAPMAC)")
					    .frame(width: 162.0,height: 22.0,alignment: .leading)
					    .textSelection(.enabled)
					    .accessibilityLabel("MAC Address of connected Access Point")
					    .accessibilityIdentifier("wapMACAddress")
				    Text("\(currentChannel)")
					    .frame(width: 162.0,height: 22.0,alignment: .leading)
					    .textSelection(.enabled)
					    .accessibilityLabel("Current Wireless Channel")
					    .accessibilityIdentifier("wirelessChannel")
			    }

			    VStack(alignment: .leading) {
				    Text("Signal Strength (dBm):")
					    .font(.body)
					    .fontWeight(.regular)
					    .frame(width: 140.0,height: 22.0,alignment: .leading)
				    Text("Signal Noise (dBm):")
					    .font(.body)
					    .fontWeight(.regular)
					    .frame(width: 140.0,height: 22.0,alignment: .leading)
				    Text("Signal To Noise (dBm):")
					    .font(.body)
					    .fontWeight(.regular)
					    .frame(width: 140.0,height: 22.0,alignment: .leading)

				    Button("Create New File") {
					    let saveURL = showSavePanel()
					    print(saveURL)
				    }
				    .padding(.top)
				    Button("Append to File") {
					    /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
				    }
			    }
			    VStack(alignment: .leading) {
				    Text("\(signalStrength)")
					    .frame(width: 43.0,height: 22.0,alignment: .leading)
					    .textSelection(.enabled)
				    Text("\(signalNoise)")
					    .frame(width: 43.0,height: 22.0,alignment: .leading)
					    .textSelection(.enabled)
				    Text("\(signalToNoise)")
					    .frame(width: 43.0,height: 22.0,alignment: .leading)
					    .textSelection(.enabled)
			    }

			    VStack(alignment: .leading) {
				    Text("Auth Mode:")
					    .font(.body)
					    .fontWeight(.regular)
					    .frame(width: 116.0,height: 22.0,alignment: .leading)
				    Text("Data Rate (Mbps):")
					    .font(.body)
					    .fontWeight(.regular)
					    .frame(width: 116.0,height: 22.0,alignment: .leading)
				    Text("Current Time:")
					    .font(.body)
					    .fontWeight(.regular)
					    .frame(width: 116.0,height: 22.0,alignment: .leading)
				    Button("Refresh") {
					    /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
				    }
				    .padding(.top)

				    Button("Track") {
					    if(!timerState) {
						    print("timer off")
						    timerState = true
						    self.startTimer()
					    } else {
						    print("timer on")
						    timerState = false
						    self.stopTimer()
					    }
				    }
			    }
			    VStack(alignment: .leading) {
				    Text("Auth Mode")
					    .frame(width: 162.0,height: 22.0,alignment: .leading)
					    .textSelection(.enabled)
				    Text("\(dataRate)")
					    .frame(width: 162.0,height: 22.0,alignment: .leading)
				    Text("\(theCurrentTime)")
					    .frame(width: 162.0,height: 22.0,alignment: .leading)
						//update the clock value
					    .onReceive(theTimer) {
						    //this sets up the field to update at the timer
						    //frequency
						    input in theCurrentTime = getCurrentTime()
					    }
			    }
		    }
		    Spacer()
	    }
	    .onAppear {
		    //set up the SSID value
		    //redo this with a function that returns all the info we need
		    //maybe as a tuple, probably as a struck so return.SSID etc.
		    currentSSID = currentSSIDs()
		    //theCurrentTime = getCurrentTime()
		    self.theCurrentTime = getCurrentTime()
		    self.stopTimer()

	    }
	   .frame(width: 785.0, height: 212.0)
	   .fixedSize()
	    
	   .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification), perform: { _ in
		   NSApp.mainWindow?.standardWindowButton(.zoomButton)?.isHidden = true
		   NSApp.mainWindow?.contentRect(forFrameRect: NSRect(x: 0, y: 0, width: 785, height: 212))
		   NSApp.mainWindow?.styleMask = [.titled, .closable, .miniaturizable]
			}
		)
    }



	//stop the timer
	func stopTimer() {
		self.theTimer.upstream.connect().cancel()
	}
	func startTimer() {
		self.theTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	}
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
