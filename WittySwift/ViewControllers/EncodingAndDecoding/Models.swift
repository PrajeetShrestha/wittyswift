//
//  Models.swift
//  PSArsenal
//
//  Created by Prajeet Shrestha on 09/06/2021.
//

import Foundation
struct Employee:Codable {
    enum CodingKeys:String, CodingKey {
        case name
        case id
        case favoriteToy = "gift"
        case address
    }
    var name:String
    var id:Int
    var favoriteToy:Toy
    var address:Address

}

struct Toy:Codable  {
    var name:String
}

struct Address:Codable {
    var ward:Int
}
