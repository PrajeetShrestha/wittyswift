//
//  GenericTableViewController.swift
//  WittySwift
//
//  Created by Prajeet Shrestha on 09/06/2021.
//

import UIKit
import FontAwesome_swift
import Photos

class ControllerListViewController: NavigationAwareViewController {
    static func instantiate(menuItems:[MenuItem], viewTitle:String? = nil) -> ControllerListViewController {
        let controller = ControllerListViewController.loadFromNib()
        controller.menuItems = menuItems
        controller.viewTitle = viewTitle ?? ""
        return controller
    }
    
    private var menuItems:[MenuItem] = []
    private var viewTitle:String = ""
    private var cellIdentifier = "MenuItemCell"
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewTitle
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        tableView.tableFooterView = UIView()
    }
}

//MARK: - TableViewDataSource
extension ControllerListViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        let item = menuItems[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.image = item.iconImage
        cell.textLabel?.text = item.getName().deleteSuffix("ViewController")
        return cell
    }
}

//MARK: - TableViewDelegate
extension ControllerListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = menuItems[indexPath.row]
        if String(describing: item.controller) == "imageserver" {
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized:
                    DispatchQueue.main.async {
                        NavigationService.shared.navigateTo(item.controller)
                    }
                default:
                    break
                }
            }
        } else {
            NavigationService.shared.navigateTo(item.controller)
        }
    }
}

