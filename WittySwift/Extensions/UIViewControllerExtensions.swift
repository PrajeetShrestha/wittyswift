//
//  UIViewControllerExtensions.swift
//  PSArsenal
//
//  Created by Prajeet Shrestha on 22/05/2021.
//

import UIKit

//MARK: - Controller Instantiations
extension UIViewController {
    func addChildController(childController:UIViewController, containerView:UIView) {
        addChild(childController)
        childController.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(childController.view, constrainedTo: containerView)
        childController.didMove(toParent: self)
    }
    
    static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            return T.init(nibName: String(describing: T.self), bundle: nil)
        }
        
        return instantiateFromNib()
    }
}
//MARK: - Alert Controllers
extension UIViewController {
    func showAlertWithOk(alertText : String, alertMessage : String) {
        let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithYesAndNoActions(alertText:String, alertMessage:String,
                                      yesAction:@escaping (UIAlertAction) -> Void,
                                      noAction: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: yesAction))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: noAction))
        self.present(alert, animated: true, completion: nil)
    }
}
