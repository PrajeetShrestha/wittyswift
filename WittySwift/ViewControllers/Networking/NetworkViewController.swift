//
//  NetworkViewController.swift
//  PSArsenal
//
//  Created by Prajeet Shrestha on 21/05/2021.
//

import UIKit
class NetworkingViewController:NavigationAwareViewController {
    
    var fetcher:DataFetcher?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetcher = NetworkDataFetcher()
        fetcher?.getTemperatures(completion: { (result) in
            switch result {
            case .success(let temp):
                print(temp)
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
}
