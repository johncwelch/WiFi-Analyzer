//
//	ContentView.swift
// 	WiFi Analyzer
//
// 	Created by John Welch on 6/9/22.
//	Note that the get<thing> functions are in WiFI_AnalyzerApp.swift
//		Not here.

import SwiftUI
import CoreWLAN
import CoreLocation

struct ContentView: View {
	//SSID value
	@State private var currentSSID: String = ""
	//current WAP MAC
	@State private var currentWAPMAC: String = ""
	//current WiFI channel
	@State private var currentChannel: Int = 0
	//signal strength in dbm
	@State private var signalStrength: Int = 0
	//signal noise in dbm
	@State private var signalNoise: Int = 0
	//SNR in dbm
	//done as string for numberformatter needs
	@State private var signalToNoise: String = "0.0"
	//data rate in Mbps
	//done as string for numberFormatteer needs
	@State private var dataRate: String = "0.0"
	//current time
	@State private var theCurrentTime: String = ""
	//security mode
	@State private var authMode: String = ""

	//checkbox state
	@State private var writeToFile = false

	//Timer setup
	@State private var theTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	//timer on/off var
	@State private var timerState: Bool = false

	@State var myLocationManager = CLLocationManager()

	//@StateObject var myLocationManagerDelegate = myLocationDelegate()

	//create interface instance
	//@State private var theWifiInterface: CWInterface = getWifiInterface()
	

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
				    Text("\(authMode)")
					    .frame(width: 162.0,height: 22.0,alignment: .leading)
					    .textSelection(.enabled)
				    Text("\(dataRate)")
					    .frame(width: 162.0,height: 22.0,alignment: .leading)
				    Text("\(theCurrentTime)")
					    .frame(width: 162.0,height: 22.0,alignment: .leading)
						//update the clock value
					    .onReceive(theTimer) {
						    //this sets up the fields to update at the timer
						    //frequency
						    input in theCurrentTime = getCurrentTime()
						    currentChannel = getCWChannelNumber()
						    signalStrength = getRSSI()
						    signalNoise = getNoise()
						    signalToNoise = getSNR(theSig: signalStrength, theNoise: signalNoise)
						    dataRate = getTransmitRate()
						    authMode = getAuthMode()
					    }
			    }
		    }
		    Spacer()
	    }
	    .onAppear {
		    let myDelegate = locationDelegate()
		    myLocationManager.requestWhenInUseAuthorization()
		    myLocationManager.startUpdatingLocation()
		    myLocationManager.delegate = myDelegate
		    myLocationManager.delegate
		    print(myLocationManager.authorizationStatus.rawValue)
		    let myLocationManagerAuthStatus = myLocationManager.authorizationStatus.rawValue
		    if myLocationManagerAuthStatus == 3 || myLocationManagerAuthStatus == 4 {
				//get BSSID
			    print("we're authorized")
			    currentWAPMAC = getBSSID()
		    }



		    //set up the SSID value
		    currentSSID = getSSID()
		    //get the Wifi Channel. if it's a zero,
		    //channel is actually nil
		    currentChannel = getCWChannelNumber()
		    //set up the RSSI
		    signalStrength = getRSSI()
		    //BRING THA NOIZE
		    signalNoise = getNoise()
		    //get the SNR as a formatted string via NumberFormatter
		    signalToNoise = getSNR(theSig: signalStrength, theNoise: signalNoise)
		    //get transmit rate
		    dataRate = getTransmitRate()
		    //get security mode
		    authMode = getAuthMode()
			//get current time
		    self.theCurrentTime = getCurrentTime()
		    //stop the timer
		    self.stopTimer()

	    }
    }

	

	//stop the timer
	func stopTimer() {
		self.theTimer.upstream.connect().cancel()
	}
	//start timer
	func startTimer() {
		self.theTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	}
	
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
