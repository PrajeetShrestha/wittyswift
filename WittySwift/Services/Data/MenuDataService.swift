//
//  MenuDataService.swift
//  PSArsenal
//
//  Created by Prajeet Shrestha on 20/05/2021.
//

import Foundation


struct MenuDataservice {
    static let menuItems: [MenuItem] = [
        MenuItem(controller: .networkMonitor),
        MenuItem(controller: .messageCenter),
        MenuItem(controller: .sandboxHome(SandboxHomeInput(data: "TestData"))),
        MenuItem(controller: .dummy),
    ]
    
    static let sandboxMenuItems: [MenuItem] = [
        MenuItem(controller:.dummy)
    ]
}

