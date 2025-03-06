//
//  MetronomeSourceType.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/3/5.
//

import Foundation

enum MetronomeSourceType: String, CaseIterable, Identifiable {
    var id: Self { self }
    
    case bassDrum
    case cowbell
    case hiHat
    case jackSlap
    case laugh
    case mechanicalMetronomeHigh
    case mechanicalMetronomeLow
    case rimshot
    
    var fileName: String {
        switch self {
        case .bassDrum: return "Bass drum"
        case .cowbell: return "Cowbell"
        case .hiHat: return "Hi-hat"
        case .jackSlap: return "Jack slap"
        case .laugh: return "LAUGH!"
        case .mechanicalMetronomeHigh: return "Mechanical metronome - High"
        case .mechanicalMetronomeLow: return "Mechanical metronome - Low"
        case .rimshot: return "Rimshot"
        }
    }
    
    var fileType: String {
        return "aif"
    }
}
