//
//  ViewController.swift
//  try.Reachability
//
//  Created by Chan Hong Wing on 25/3/2019.
//  Copyright © 2019 Chan Hong Wing. All rights reserved.
//

import UIKit
import Reachability
class ViewController: UIViewController {


    @IBOutlet weak var networkStatus: UILabel!
    @IBOutlet weak var bssidLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ReachabilityManager.shared.addListener(listener: self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        ReachabilityManager.shared.removeListener(listener: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension ViewController: NetworkStatusListener {
    
    func networkStatusDidChange(status: Reachability.Connection) {
        switch status {
        case .none:
            debugPrint("ViewController: Network became unreachable")
            networkStatus.text = "none"
            bssidLabel.text = "BSSID : "
        case .wifi:
            networkStatus.text = "WiFi"
            debugPrint("ViewController: Network reachable through WiFi")
        case .cellular:
            networkStatus.text = "Cellular"
            bssidLabel.text = "BSSID : "
            debugPrint("ViewController: Network reachable through Cellular Data")
        }
    }
    
    func bssidDidChange(bssid: String) {
        bssidLabel.text = "BSSID: \(bssid)"
    }

}
