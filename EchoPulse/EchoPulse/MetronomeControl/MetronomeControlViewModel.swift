//
//  MetronomeControlViewModel.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/2/10.
//

import Foundation
import Observation

@Observable
final class MetronomeControlViewModel {
    var isPlaying = false
    var sourceType: MetronomeSourceType {
        didSet {
            self.metronome.changeSoundType(sourceType)
        }
    }
    
    var bpm: Double
    var volume: Double

    private var metronome: Metronome

    init() {
        let storageBPM = UDUtils.getValue(for: UDKeys.storageBPM)
        let storageVolume = UDUtils.getValue(for: UDKeys.storageVolume)
        let storageSourceType = UDUtils.getValue(for: UDKeys.storageSourceType)
        
        self.bpm = storageBPM
        self.volume = storageVolume
        self.sourceType = storageSourceType
        self.metronome = Metronome(bpm: storageBPM, volume: storageVolume, sourceType: storageSourceType)
    }

    func togglePlay() {
        isPlaying.toggle()
        if (isPlaying) {
            metronome.start()
        } else {
            metronome.stop()
        }
    }

    func updateBPM(_ newValue: Double) {
        bpm = newValue
        if isPlaying {
            metronome.updateBPM(bpm: newValue)
        }
    }

    func updateVolume(_ newValue: Double) {
        volume = newValue
        metronome.updateVolume(volume: volume)
    }
}

extension UDKeys {
    static let storageBPM = UDKey<Double>("MetronomeControl.BPM", defaultValue: 120)
    static let storageVolume = UDKey<Double>("MetronomeControl.Volume", defaultValue: 0.5)
    static let storageSourceType = UDKey<MetronomeSourceType>("MetronomeControl.SourceType", defaultValue: .bassDrum)
}
