//
//  MenuDataService.swift
//  PSArsenal
//
//  Created by Prajeet Shrestha on 20/05/2021.
//

import UIKit
import FontAwesome_swift

struct Icons {
    static let size = CGSize(width: 20, height: 20)
    
    static var color: UIColor { return .darkGray }
    
    static let utilities:UIImage = UIImage.fontAwesomeIcon(name: .hammer, style: .solid, textColor: color, size: size)
    static let network:UIImage = UIImage.fontAwesomeIcon(name: .networkWired, style: .solid, textColor: color, size: size)
    static let sandbox:UIImage = UIImage.fontAwesomeIcon(name: .tools, style: .solid, textColor: color, size: size)
    static let dummy:UIImage = UIImage.fontAwesomeIcon(name: .angry, style: .solid, textColor: color, size: size)
    
    static let messageCenter:UIImage = UIImage.fontAwesomeIcon(name: .bullhorn, style: .solid, textColor: color, size: size)
    static let networkMonitor:UIImage = UIImage.fontAwesomeIcon(name: .wifi, style: .solid, textColor: color, size: size)
    static let encoding:UIImage = UIImage.fontAwesomeIcon(name: .qrcode, style: .solid, textColor: color, size: size)
}

struct MenuDataservice {
    static let homeMenuItems: [MenuItem] = [
        MenuItem(controller: .list(MenuDataservice.utilityMenuItems, "Utilities"), iconImage: Icons.utilities),
        MenuItem(controller: .networking, iconImage: Icons.network),
        MenuItem(controller: .list(MenuDataservice.sandboxMenuItems, "Sandbox"), iconImage: Icons.sandbox),
        MenuItem(controller: .webrtc, iconImage: nil)
    ]
    
    static var utilityMenuItems: [MenuItem] {
        #if targetEnvironment(simulator)
        return [MenuItem(controller: .messageCenter, iconImage: Icons.messageCenter),
                MenuItem(controller: .encodingHome, iconImage: Icons.encoding)]
        #else
        return [MenuItem(controller: .messageCenter, iconImage: Icons.messageCenter),
                MenuItem(controller: .networkMonitor, iconImage: Icons.networkMonitor),
                MenuItem(controller: .encodingHome, iconImage: Icons.encoding)]
        #endif
    }
    
    static let sandboxMenuItems: [MenuItem] = [
        MenuItem(controller:.dummy)
    ]
}

