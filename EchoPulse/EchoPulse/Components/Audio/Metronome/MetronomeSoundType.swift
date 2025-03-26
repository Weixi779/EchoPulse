//
//  MetronomeSourceType.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/3/5.
//

import Foundation

enum MetronomeSoundType: CaseIterable, Identifiable, Codable {
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
    
    var systemIconName: String {
        switch self {
        case .bassDrum: return "speaker.wave.3"
        case .cowbell: return "bell"
        case .hiHat: return "music.note.list"
        case .jackSlap: return "hand.raised"
        case .laugh: return "face.smiling"
        case .mechHigh: return "metronome"
        case .mechLow: return "metronome.fill"
        case .rimshot: return "circle.grid.cross"
        }
    }
    
    var description: String {
        switch self {
        case .bassDrum: return "低沉有力的鼓声"
        case .cowbell: return "清脆明亮的铃声"
        case .hiHat: return "清晰的打击声"
        case .jackSlap: return "干脆利落的击打声"
        case .laugh: return "有趣的笑声效果"
        case .mechHigh: return "传统高音节拍器"
        case .mechLow: return "传统低音节拍器"
        case .rimshot: return "鼓边缘敲击声"
        }
    }
    
    var fileType: String {
        return "aif"
    }
}
