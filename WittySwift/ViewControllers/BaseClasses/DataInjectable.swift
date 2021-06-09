//
//  DataInjectable.swift
//  PSArsenal
//
//  Created by Prajeet Shrestha on 27/05/2021.
//

import UIKit

protocol DataInjectable:UIViewController {
    associatedtype Input
    var inputData:Input? {get set}
}

