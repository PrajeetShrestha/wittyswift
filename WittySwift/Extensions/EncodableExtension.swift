//
//  EncodableExtension.swift
//  WittySwift
//
//  Created by Prajeet Shrestha on 09/06/2021.
//

import Foundation
extension Encodable {
    
    /// This property allows you to get a dictionary value from Encodable object. This is equivalent to convertToDictionary method
    var dictionary : [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else { return nil }
        return json
    }
    
    /// This method allows you to get a dictionary value from Encodable object. This is equivalent to dictionary property.
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
    
    // Converts all the keys of dictionary into lowercased key.
    func convertToLowercaseKeyedDictionary() throws -> [String:Any] {
        var dict = try convertToDictionary()
        for key in dict.keys {
            dict[key.lowercased()] = dict.removeValue(forKey: key)
        }
        return dict
    }
}
