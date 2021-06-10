//
//  ControllerService.swift
//  PSArsenal
//
//  Created by Prajeet Shrestha on 20/05/2021.
//
import UIKit
import FontAwesome_swift

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
        
        let homeNav = UINavigationController(rootViewController: controller.instance)
      
        let aboutViewController = AppController.about.instance
        let aboutNav = UINavigationController(rootViewController: aboutViewController)
        
        let tabBarControler = UITabBarController()
        
        tabBarControler.viewControllers = [
            homeNav,aboutNav
        ]
        setupTabBarAppearance(tabBarControler: tabBarControler)
        window.rootViewController = tabBarControler
        window.makeKeyAndVisible()
   
    }
    
    func navigateTo(_ controller:AppController) {
        if let nav = currentController?.navigationController {
            nav.show(controller.instance, sender: nil)
        }
    }
    
    func setupTabBarAppearance(tabBarControler:UITabBarController){
        let firstTabItem = tabBarControler.tabBar.items![0]
        let secondTabItem = tabBarControler.tabBar.items![1]
    
        firstTabItem.title = "Home"
        secondTabItem.title = "About"
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
        tabBarControler.tabBar.tintColor = .black
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal)
        firstTabItem.image = UIImage.fontAwesomeIcon(
            name: .code,
            style: .solid,
            textColor: .black,
            size: CGSize(width: 20, height: 20))
        
        secondTabItem.image = UIImage.fontAwesomeIcon(
            name: .info,
            style: .solid,
            textColor: .black,
            size: CGSize(width: 20, height: 20))
    }
}




