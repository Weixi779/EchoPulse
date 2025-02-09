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
    var frequency: Double
    var duration: Double
    var volume: Double

    private var metronome: Metronome

    init(metronome: Metronome = Metronome(bpm: 120, frequency: 1000, duration: 0.05, volume: 0.5)) {
        self.metronome = metronome
        self.bpm = metronome.bpm
        self.frequency = metronome.frequency
        self.duration = metronome.duration
        self.volume = metronome.volume
    }

    func togglePlay() {
        isPlaying.toggle()
        if isPlaying {
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

    func updateFrequency(_ newValue: Double) {
        frequency = newValue
        metronome.updateSound(frequency: frequency, duration: duration, volume: volume)
    }

    func updateDuration(_ newValue: Double) {
        duration = newValue
        metronome.updateSound(frequency: frequency, duration: duration, volume: volume)
    }

    func updateVolume(_ newValue: Double) {
        volume = newValue
        metronome.updateSound(frequency: frequency, duration: duration, volume: volume)
    }
}
