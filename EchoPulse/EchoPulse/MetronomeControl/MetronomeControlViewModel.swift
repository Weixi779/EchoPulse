//
//  MetronomeControlViewModel.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/2/10.
//

import Foundation

@Observable
class MetronomeControlViewModel {
    var isPlaying = false
    var bpm: Double
    var volume: Double

    private var metronome: Metronome

    init(metronome: Metronome = Metronome(bpm: 120, volume: 0.5)) {
        self.metronome = metronome
        self.bpm = metronome.bpm
        self.volume = metronome.volume
    }

    func togglePlay() {
        isPlaying.toggle()
        if (isPlaying) {
            metronome.start(bpm: bpm)
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
