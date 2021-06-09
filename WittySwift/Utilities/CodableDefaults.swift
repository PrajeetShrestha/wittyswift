//
//  Defaults.swift
//  PSArsenal
//
//  Created by Prajeet Shrestha on 22/05/2021.
//

import Foundation

enum CodableDefaults:String {
    case loggedInUser
    case settings
    
    /*
     set:
     This method cannot infer the return type unless the variable that will store the returned data has the type defined explicitly.
     Example:
     let person:[Person] = AkCodableDefaults().selectedBrand.get()
     Note: Here person variable has [Person] type explicitly defined.
     */
    
    func set<T:Codable>(value:T) throws {
        let std = UserDefaults.standard
        do {
            let encodedValue = try JSONEncoder().encode(value)
            std.set(encodedValue, forKey: self.rawValue)
        } catch let error {
            throw NSError(domain: "Couldn't save object to defaults: \(error.localizedDescription)", code: 101, userInfo: nil)
        }
    }

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
