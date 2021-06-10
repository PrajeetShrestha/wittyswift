//
//  HomeModels.swift
//  PSArsenal
//
//  Created by Prajeet Shrestha on 20/05/2021.
//

import UIKit

struct MenuItem {
    var controller:AppController
    var iconImage:UIImage?
    
    func getName() -> String {
        switch controller {
        case .list(_, let title):
            return title
        default:
            return controller.name.rawValue
        }
    }
}
