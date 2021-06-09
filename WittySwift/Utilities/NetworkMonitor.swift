//
//  NetworkMonitor.swift
//  PSArsenal
//
//  Created by Prajeet Shrestha on 01/06/2021.
//

import Foundation
import Network

/// NetworkMonitor will only work in real devices. The satisfied block might get called multiple times.
class NetworkMonitor {
    public static let shared = NetworkMonitor()
    let queue = DispatchQueue(label: "Monitor")
    private init() {}
    
    var isConnected = false {
        didSet {
            if isConnected {
                self.messageCenter.send(name: .networkConnected)
            } else {
                self.messageCenter.send(name: .networkDisconnected)
            }
        }
    }
    let monitor = NWPathMonitor()
    let messageCenter = MessageCenter()
    
    func startMonitoringNetwork() {
        #if targetEnvironment(simulator)
        isConnected = true
        #else
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {[weak self] in
                guard let self = self else { return }
                if path.status == .satisfied {
                    //Do nothing if previous state is connected
                    if self.isConnected { return }
                    self.isConnected = true
                } else {
                    //Do nothing if previous state is not connected
                    if !self.isConnected { return }
                    self.isConnected = false
                }
                self.isSetForTheFirstTime = true
            }
        }
        monitor.start(queue: queue)
        #endif
    }
}
