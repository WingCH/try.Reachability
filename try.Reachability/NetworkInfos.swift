//
//  NetworkInfos.swift
//  try.Reachability
//
//  Created by Chan Hong Wing on 28/3/2019.
//  Copyright © 2019 Chan Hong Wing. All rights reserved.
//

import UIKit
import SystemConfiguration.CaptiveNetwork

struct NetworkInfo {
    public let interface:String
    public let ssid:String
    public let bssid:String
    init(_ interface:String, _ ssid:String,_ bssid:String) {
        self.interface = interface
        self.ssid = ssid
        self.bssid = bssid
    }
}

class NetworkInfos: NSObject {
    
    func getNetworkInfos() -> Array<NetworkInfo> {
        // https://forums.developer.apple.com/thread/50302
        guard let interfaceNames = CNCopySupportedInterfaces() as? [String] else {
            print("no interfaceNames")
            return []
        }
        
        let networkInfos:[NetworkInfo] = interfaceNames.compactMap{ name in
            guard let info = CNCopyCurrentNetworkInfo(name as CFString) as? [String:AnyObject] else {
                print("no info")
                return nil
            }
            guard let ssid = info[kCNNetworkInfoKeySSID as String] as? String else {
                print("no ssid")
                return nil
            }
            guard let bssid = info[kCNNetworkInfoKeyBSSID as String] as? String else {
                print("no bssid")
                return nil
            }
            return NetworkInfo(name, ssid,bssid)
        }
        return networkInfos
    }
}
