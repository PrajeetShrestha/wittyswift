//
//  BaseViewController.swift
//  PSArsenal
//
//  Created by Prajeet Shrestha on 20/05/2021.
//

import UIKit

class NavigationAwareViewController:BaseViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NavigationService.shared.currentController = self
    }
}
