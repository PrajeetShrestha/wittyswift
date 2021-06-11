//
//  NewNavigationService.swift
//  PSArsenal
//
//  Created by Prajeet Shrestha on 27/05/2021.
//

import UIKit

enum AppController {
    case list([MenuItem], String)
    case messageCenter
    case networkMonitor
    case networking
    case encodingHome
    case dummy
    case about
    case webrtc
    
    var name: ControllerName {
        switch self {
        case .list: return .Common
        case .messageCenter: return .MessageCenterViewController
        case .networkMonitor: return .NetworkMonitorViewController
        case .networking: return .NetworkingViewController
        case .encodingHome: return .EncodingHomeViewController
        case .dummy: return .DummyViewController
        case .about: return .AboutViewController
        case .webrtc: return .WebRTCViewController
        
        }
    }
    
    var storyboard: StoryboardName {
        switch self {
        case .networking, .about: return .Main
        case .messageCenter, .networkMonitor, .encodingHome, .dummy: return .Utilities
        case .webrtc: return .WebRTC
        default: return .Main
        }
    }
    
    var instance: UIViewController {
        let sb = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        switch self {
        case .list(let items, let title):
            return ControllerListViewController.instantiate(menuItems:items, viewTitle: title)
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
    case AboutViewController
    case Common
    case WebRTCViewController
}

enum StoryboardName:String, CaseIterable {
    case Main
    case Utilities
    case Sandbox
    case WebRTC
}
