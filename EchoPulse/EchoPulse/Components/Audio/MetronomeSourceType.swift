//
//  MetronomeSourceType.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/3/5.
//

import Foundation

enum MetronomeSourceType: CaseIterable, Identifiable, Codable {
    var id: Self { self }
    
    case bassDrum
    case cowbell
    case hiHat
    case jackSlap
    case laugh
    case mechHigh
    case mechLow
    case rimshot
    
    var fileName: String {
        switch self {
        case .bassDrum: return "Bass drum"
        case .cowbell: return "Cowbell"
        case .hiHat: return "Hi-hat"
        case .jackSlap: return "Jack slap"
        case .laugh: return "LAUGH!"
        case .mechHigh: return "Mech - High"
        case .mechLow: return "Mech - Low"
        case .rimshot: return "Rimshot"
        }
    }
    
    var fileType: String {
        return "aif"
    }
}

extension MetronomeSourceType: Comparable {
    public static func < (lhs: MetronomeSourceType, rhs: MetronomeSourceType) -> Bool {
        guard let lhsIndex = Self.allCases.firstIndex(of: lhs),
              let rhsIndex = Self.allCases.firstIndex(of: rhs) else {
            fatalError("所有枚举值都应存在于 allCases 中")
        }
        return lhsIndex < rhsIndex
    }
}

extension MetronomeSourceType {
    func compare(to other: MetronomeSourceType) -> Int {
        if self < other {
            return -1
        } else if self > other {
            return 1
        } else {
            return 0
        }
    }
}
