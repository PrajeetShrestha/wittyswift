//
//  SandboxHomeViewController.swift
//  PSArsenal
//
//  Created by Prajeet Shrestha on 22/05/2021.
//

import UIKit

struct SandboxHomeInput {
    var data:String
}
class SandboxHomeViewController:NavigationAwareViewController {

    var inputData:SandboxHomeInput
    
    private var tableView:UITableView!
    private var menuItems = MenuDataservice.sandboxMenuItems
    private let cellIdentifier = "MenuCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = inputData.data
        setupTableView()
    }
    
    init?(coder:NSCoder,input:SandboxHomeInput) {
        inputData = input
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupTableView() {
        tableView = UITableView(frame: view.bounds)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
}

extension SandboxHomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        let item = menuItems[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = item.controller.name.rawValue.deleteSuffix("ViewController")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = menuItems[indexPath.row]
        NavigationService.shared.navigateTo(item.controller)
    }
}
