//
//  NetworkMonitorViewController.swift
//  PSArsenal
//
//  Created by Prajeet Shrestha on 20/05/2021.
//

import UIKit

/// This demo won't work as expected in Simulator
class NetworkMonitorViewController: NavigationAwareViewController {
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMessage.text = NetworkMonitor.shared.isConnected ? "Connected" : "Not Connected"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageCenter.observe(name: .networkConnected) { [weak self] _ in
            self?.lblMessage.text = "Connected"
        }
        
        messageCenter.observe(name: .networkDisconnected) {[weak self] _ in
            self?.lblMessage.text = "Not Connected"
        }
    }
}

