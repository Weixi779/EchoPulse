//
//  UDUtils.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/3/8.
//

import Foundation

struct UserDefaultsUtils {
    // 泛型读取方法
    static func getValue<T: Codable>(for key: UserDefaultsKey<T>) -> T {
        guard let data = UserDefaults.standard.data(forKey: key.rawKey) else {
            return key.defaultValue
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Error decoding \(T.self) for key \(key.rawKey): \(error)")
            return key.defaultValue
        }
    }
    
    // 泛型写入方法
    static func setValue<T: Codable>(_ value: T, for key: UserDefaultsKey<T>) {
        do {
            let data = try JSONEncoder().encode(value)
            UserDefaults.standard.set(data, forKey: key.rawKey)
        } catch {
            print("Error encoding \(T.self) for key \(key.rawKey): \(error)")
        }
    }
}

extension UserDefaultsUtils {
    static var bpm: UserDefaultsKey<Double> { .bpm }
    static var volume: UserDefaultsKey<Double> { .volume }
    static var sourceType: UserDefaultsKey<MetronomeSourceType> { .sourceType }
}
