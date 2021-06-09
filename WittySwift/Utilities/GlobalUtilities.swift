//
//  Globals.swift
//  PSArsenal
//
//  Created by Prajeet Shrestha on 23/05/2021.
//

import Foundation

/// Method to get codable objects from the JSON File in the bundle
/// - Parameter name: Name of a JSON file in the bundle
/// - Throws: NSError if JSON file is not found in a bundle, Error if can't decode objects in JSON.
/// - Returns: Decodable Object specified
///
/// **Example**
///
///     let employees:[Employee] = try! fetchJsonFromFileInBundle("employees")
func fetchJsonFromFileInBundle<T:Decodable>(_ name:String) throws ->T {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    if let path = Bundle.main.path(forResource: name, ofType: "json") {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path),
                                options: [])
            let employees = try decoder.decode(T.self, from: data)
            return employees
        } catch {
            throw error
        }
    }
    throw NSError(domain: "Can't find json file", code: 101, userInfo: nil)
}


/// Method to convert dictionary into Decodable Object
/// - Parameter dictionary: Dictionary object to convert.
/// - Throws: Error if dictionary can't be converted into specified Decodable Object
/// - Returns: Decodable Object
func getValueFromDictionary<T:Decodable>(dictionary: [String:Any]) throws-> T {
    do {
        let json = try JSONSerialization.data(withJSONObject: dictionary)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let decodedValue = try decoder.decode(T.self, from: json)
        return decodedValue
    } catch {
        throw error
    }
}


    







