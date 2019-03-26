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
    @IBOutlet weak var hostNameLabel: UILabel!
    
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
//        ReachabilityManager.shared.startMonitoring()
    }

}

extension ViewController: NetworkStatusListener {
    
    func networkStatusDidChange(status: Reachability.Connection) {
        
        switch status {
        case .none:
            debugPrint("ViewController: Network became unreachable")
        case .wifi:
            networkStatus.text = "wifi"
            debugPrint("ViewController: Network reachable through WiFi")
        case .cellular:
            networkStatus.text = "cellular"
            debugPrint("ViewController: Network reachable through Cellular Data")
        }
    }
}
