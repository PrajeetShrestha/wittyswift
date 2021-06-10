//
//  Defaults.swift
//  PSArsenal
//
//  Created by Prajeet Shrestha on 22/05/2021.
//

import Foundation

/// Utility class to store Codable objects in UserDefaults
enum CodableDefaults:String {
    case loggedInUser
    case settings
    
    /// Method to store codable objects into user defaults.
    /// - Parameter value: Codable Object
    /// - Throws: NSError if it can't save codable objects into dictionary
    ///
    /// **Example**
    ///
    ///     let user = User(name:"Prajeet")
    ///
    ///     try CodableDefaults.set(user)
    ///
    func set<T:Codable>(value:T) throws {
        let std = UserDefaults.standard
        do {
            let encodedValue = try JSONEncoder().encode(value)
            std.set(encodedValue, forKey: self.rawValue)
        } catch let error {
            throw NSError(domain: "Couldn't save object to defaults: \(error.localizedDescription)", code: 101, userInfo: nil)
        }
         
    }
    
    /// Method to get a codable object from User Defaults
    /// - Returns: Codable Object or nil
    ///
    ///**Example**
    ///
    ///     let employee:Employee? = CodableDefaults.loggedInUser.get()
    ///
    func get<T:Codable>() -> T? {
        let std = UserDefaults.standard
        if let value = std.object(forKey: self.rawValue) as? Data {
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: value)
                return decodedObject
            } catch let error {
                print(error.localizedDescription)
                return nil
            }
        } else {
            return nil
        }
    }
    
    
    func remove() {
        let std = UserDefaults.standard
        std.removeObject(forKey: self.rawValue)
    }
}
