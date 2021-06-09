//
//  EncodingHomeViewController.swift
//  PSArsenal
//
//  Created by Prajeet Shrestha on 23/05/2021.
//

import Foundation
//References: https://www.raywenderlich.com/3418439-encoding-and-decoding-in-swift
class EncodingHomeViewController:NavigationAwareViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchJsonFromFile()
    
    }
    
    func fetchJsonFromFile() {
        let employees:[Employee] = try! fetchJsonFromFileInBundle("employees")
        if let first = employees.first {
            let encoder = JSONEncoder()
            let data = try! encoder.encode(first)
            let string = String(data: data, encoding: .utf8)
            print(string ?? "")
        }
        print(employees)
    }
    
}
