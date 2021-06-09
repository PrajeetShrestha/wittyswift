//
//  NewNavigationService.swift
//  PSArsenal
//
//  Created by Prajeet Shrestha on 27/05/2021.
//

import UIKit

enum AppController {
    case home
    case messageCenter
    case networkMonitor
    case networking
    case sandboxHome(SandboxHomeInput)
    case encodingHome
    case dummy

    var name: ControllerName {
        switch self {
        case .home: return .HomeViewController
        case .messageCenter: return .MessageCenterViewController
        case .networkMonitor: return .NetworkMonitorViewController
        case .networking: return .NetworkingViewController
        case .sandboxHome: return .SandboxHomeViewController
        case .encodingHome: return .EncodingHomeViewController
        case .dummy: return .DummyViewController
        
        }
    }
    
    var storyboard: StoryboardName {
        switch self {
        case .home, .networking: return .Main
        case .messageCenter, .networkMonitor, .encodingHome, .dummy: return .Utilities
        case .sandboxHome: return .Sandbox
        }
    }
    
    var instance: UIViewController {
        let sb = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        switch self {
        case .sandboxHome(let data):
            let sandboxVc = sb.instantiateViewController(identifier: name.rawValue) { coder in
                return SandboxHomeViewController(coder: coder, input: data)
            }
            return sandboxVc
        default:
            return sb.instantiateViewController(withIdentifier: name.rawValue)
        }
    }
}

enum ControllerName:String, CaseIterable {
   case HomeViewController
   case MessageCenterViewController
   case NetworkMonitorViewController
   case NetworkingViewController
   case SandboxHomeViewController
   case EncodingHomeViewController
   case DummyViewController
}

enum StoryboardName:String, CaseIterable {
   case Main
   case Utilities
   case Sandbox
}
