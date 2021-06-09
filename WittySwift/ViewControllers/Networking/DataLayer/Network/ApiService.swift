//
//  ApiService.swift
//  PSArsenal
//
//  Created by Prajeet Shrestha on 22/05/2021.
//

import Moya

enum PSApi {
    case temperature
}

extension PSApi: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "http://spiralinterview.herokuapp.com/") else { fatalError() }
        return url
    }
    
    var path: String {
        switch self {
        case .temperature:
            return "temperatures"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .temperature:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
