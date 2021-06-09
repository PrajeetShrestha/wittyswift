//
//  ExtensionForClassName.swift
//  PSArsenal
//
//  Created by Prajeet Shrestha on 21/05/2021.
//

import UIKit
protocol NameDescribable {
    var typeName: String { get }
    static var typeName: String { get }
}

extension NameDescribable {
    var typeName: String {
        return String(describing: type(of: self))
    }

    static var typeName: String {
        return String(describing: self)
    }
}

extension NSObject: NameDescribable {}
extension Array: NameDescribable {}
extension UIBarStyle: NameDescribable { }
