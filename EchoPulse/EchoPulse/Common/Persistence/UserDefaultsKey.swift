//
//  UserDefaultsKey.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/3/21.
//

import Foundation

enum UserDefaultsKey<T: Codable> {
    case bpm
    case volume
    case sourceType
    
    // 每个键的元数据
    var rawKey: String {
        switch self {
        case .bpm: return "MetronomeControl.BPM"
        case .volume: return "MetronomeControl.Volume"
        case .sourceType: return "MetronomeControl.SourceType"
        }
    }
    
    var defaultValue: T {
        switch self {
        case .bpm where T.self == Double.self:
            return 120.0 as! T
        case .volume where T.self == Double.self:
            return 0.5 as! T
        case .sourceType where T.self == MetronomeSourceType.self:
            return MetronomeSourceType.bassDrum as! T
        default:
            fatalError("Invalid default value for key \(self)")
        }
    }
}
