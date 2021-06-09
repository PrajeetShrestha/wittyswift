//
//  ViewController.swift
//  PSArsenal
//
//  Created by Prajeet Shrestha on 20/05/2021.
//

import UIKit
import Combine

class HomeViewController:NavigationAwareViewController {
    
    @IBOutlet weak var menuTable: UITableView!
    var menuItems:[MenuItem] {
        return MenuDataservice.menuItems
    }
    
    private let menuCellIdentifier = "MenuCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        menuTable.register(UITableViewCell.self, forCellReuseIdentifier: menuCellIdentifier)
    }
}

//MARK: - TableViewDataSource
extension HomeViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: menuCellIdentifier)!
        let item = menuItems[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = item.controller.name.rawValue.deleteSuffix("ViewController")
        return cell
    }
}

//MARK: - TableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = menuItems[indexPath.row]
        NavigationService.shared.navigateTo(item.controller)
    }
}

