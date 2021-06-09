//
//  ResponseModels.swift
//  PSArsenal
//
//  Created by Prajeet Shrestha on 22/05/2021.
//

import Foundation
struct BaseResponse<T:Codable>:Codable {
    var data:T
}

struct Month:Codable {
    var month:String
    var index:Int
    var temperature:Temperature
}

struct Temperature:Codable {
    var unit:String
    var value:Double
}
