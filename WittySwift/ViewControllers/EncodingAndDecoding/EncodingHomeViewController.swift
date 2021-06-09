//
//  EncodingHomeViewController.swift
//  PSArsenal
//
//  Created by Prajeet Shrestha on 23/05/2021.
//

import UIKit
//References: https://www.raywenderlich.com/3418439-encoding-and-decoding-in-swift
class EncodingHomeViewController:NavigationAwareViewController {
    
    @IBOutlet weak var lblMessage: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let employee = fetchEmployee()
        lblMessage.attributedText =
            NSMutableAttributedString()
                .bold("ID: ")
            .normal("\(employee.id)\n\n")
            .bold("Name: ")
            .normal("\(employee.name)\n\n")
            .underlined("Gift: \(employee.favoriteToy.name)\n\n")
            .orangeHighlight("Ward: \(employee.address.ward)")
    }
    
    func fetchEmployee() -> Employee {
        let employees:[Employee] = try! fetchJsonFromFileInBundle("employees")
        return employees.first!
    }
    
}
