//
//  ControllerService.swift
//  PSArsenal
//
//  Created by Prajeet Shrestha on 20/05/2021.
//
import UIKit

class NavigationService {
    static let shared = NavigationService()
    private init() { }
    
    var currentController:NavigationAwareViewController?
    var window: UIWindow?
    
    /// Sets Root Controller of the application
    /// - Parameter controllerName: Name of controller to be  set as rootviewcontroller
    func setRoot(controller:AppController) {
        guard let window = window else {
            print("No window set")
            return
        }
        let navigationController = UINavigationController(rootViewController: controller.instance)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func navigateTo(_ controller:AppController) {
        if let nav = currentController?.navigationController {
            nav.show(controller.instance, sender: nil)
        }
    }
}




