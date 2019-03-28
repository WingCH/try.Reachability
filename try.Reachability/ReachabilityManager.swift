//
//  ReachabilityManager.swift
//  try.Reachability
//
//  Created by Chan Hong Wing on 25/3/2019.
//  Copyright © 2019 Chan Hong Wing. All rights reserved.
//

import UIKit
import Reachability

//https://medium.com/@sauvik_dolui/network-status-monitoring-on-ios-part-1-9a22276933dc
//https://medium.com/@sauvik_dolui/network-reachability-status-monitoring-on-ios-part-2-80421fc44fa


/// Protocol for listenig network status change
public protocol NetworkStatusListener : class {
    func networkStatusDidChange(status: Reachability.Connection)
    func bssidDidChange(bssid: String)
}

class ReachabilityManager: NSObject {
    
    static  let shared = ReachabilityManager() // 2. Shared instance
    
    var bssidCheckTimer: Timer?
    
    // 3. Boolean to track network reachability
    var isNetworkAvailable : Bool {
        return reachabilityStatus != .none
    }
    
    // 4. Tracks current NetworkStatus (notReachable, reachableViaWiFi, reachableViaWWAN)
    var reachabilityStatus: Reachability.Connection = .none
    
    // 5. Reachability instance for Network status monitoring
    let reachability = Reachability()!
    
    // 6. Array of delegates which are interested to listen to network status change
    var listeners = [NetworkStatusListener]()
    
    var bssids = [String]()
    
    @objc func reachabilityChanged(notification: Notification) {
        let reachability = notification.object as! Reachability
        switch reachability.connection {
        case .none:
            debugPrint("Network became unreachable")
            stopTimer()
        case .wifi:
            debugPrint("Network reachable through WiFi")
            startTimer()
        case .cellular:
            debugPrint("Network reachable through Cellular Data")
            stopTimer()
        }
        
        // Sending message to each of the delegates
        for listener in listeners {
            listener.networkStatusDidChange(status: reachability.connection)
        }
    }
    
    func startMonitoring() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.reachabilityChanged),
                                               name: Notification.Name.reachabilityChanged,
                                               object: reachability)
        do{
            try reachability.startNotifier()
        } catch {
            debugPrint("Could not start reachability notifier")
        }
    }
    
    /// Stops monitoring the network availability status
    func stopMonitoring(){
        stopTimer()
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name.reachabilityChanged,
                                                  object: reachability)
    }
    
  
    /// Adds a new listener to the listeners array
    ///
    /// - parameter delegate: a new listener
    func addListener(listener: NetworkStatusListener){
        listeners.append(listener)
    }
    
    /// Removes a listener from listeners array
    ///
    /// - parameter delegate: the listener which is to be removed
    func removeListener(listener: NetworkStatusListener){
        listeners = listeners.filter{ $0 !== listener}
    }
    
    func startTimer() {
        print("startTimer")
        if bssidCheckTimer == nil {
            bssidCheckTimer =  Timer.scheduledTimer(
                timeInterval: 1,
                target      : self,
                selector    : #selector(self.checkBSSID),
                userInfo    : nil,
                repeats     : true)
        }
    }
    
    func stopTimer() {
        print("stopTimer")
        if bssidCheckTimer != nil {
            bssidCheckTimer!.invalidate()
            bssidCheckTimer = nil
        }
    }
    
    @objc func checkBSSID() {
        
        guard !NetworkInfos.init().getNetworkInfos().isEmpty else{
            return
        }
        
        let currentBSSID = NetworkInfos.init().getNetworkInfos()[0].bssid

        //第一次
        if bssids.isEmpty{
            bssids.append(currentBSSID)
            for listener in listeners {
                listener.bssidDidChange(bssid: currentBSSID)
            }
        }else{
            if let lastBSSID = bssids.last {
                //如果當前bssid同最新list個bssid唔同
                if currentBSSID != lastBSSID{
                    bssids.append(currentBSSID)
                    for listener in listeners {
                        listener.bssidDidChange(bssid: currentBSSID)
                    }
                }
            }
        }
        
    }
}

