//
//  DatalayerProtocol.swift
//  PSArsenal
//
//  Created by Prajeet Shrestha on 22/05/2021.
//

import Foundation

protocol DataFetcher {
    func getTemperatures(completion: @escaping (Result<[Month], Error>) -> ())
    func getResponse(completion: @escaping (Result<Bool, Error>) -> ())
}
