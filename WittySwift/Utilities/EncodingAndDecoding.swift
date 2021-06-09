//
//  Globals.swift
//  PSArsenal
//
//  Created by Prajeet Shrestha on 23/05/2021.
//

import Foundation

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

extension Encodable {
    
    var dictionary : [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else { return nil }
        return json
    }
    
    func convertToDictionary() throws -> [String:Any] {
        do {
            let data = try JSONEncoder().encode(self)
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else {
                throw NSError(domain: "Serialization failure", code: 101, userInfo: nil)
            }
            return json
        } catch {
            throw error
        }
    }
    
    func convertToLowercaseKeyedDictionary() throws -> [String:Any] {
        var dict = try convertToDictionary()
        for key in dict.keys {
            dict[key.lowercased()] = dict.removeValue(forKey: key)
        }
        return dict
    }
}
    







