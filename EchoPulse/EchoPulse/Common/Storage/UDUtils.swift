//
//  UDUtils.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/3/8.
//

import Foundation

struct UDKey<T: Codable> {
    let key: String
    let defaultValue: T
    
    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

enum UDKeys { }

struct UDUtils {

    static func getValue<T: Codable>(for item: UDKey<T>,container: UserDefaults = .standard) -> T {
        guard let data = container.data(forKey: item.key) else {
            return item.defaultValue
        }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            return item.defaultValue
        }
    }
    
    static func setValue<T: Codable>(_ value: T, for item: UDKey<T>, container: UserDefaults = .standard) {
        do {
            let data = try JSONEncoder().encode(value)
            container.set(data, forKey: item.key)
        } catch {
           
        }
    }
}
