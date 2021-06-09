//
//  BaseViewController.swift
//  PSArsenal
//
//  Created by Prajeet Shrestha on 21/05/2021.
//

import UIKit
class BaseViewController: UIViewController {
    let messageCenter = MessageCenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = typeName.deleteSuffix("ViewController")
    }
}



