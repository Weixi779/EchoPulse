//
//  MetronomeControlViewModel.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/2/10.
//

import Foundation
import Observation
import Combine

@Observable
final class MetronomeControlViewModel {
    var sourceType: MetronomeSourceType {
        didSet {
            sourceTypeSubject.send(sourceType)
        }
    }
    
    var sourceTypeSubject = PassthroughSubject<MetronomeSourceType, Never>()
    
    var bpm: Double
    var volume: Double
    
    var isPlaying = false
    private var metronome: Metronome
    private var cancellable = Set<AnyCancellable>()

    init() {
        self.bpm = UserDefaultsUtils.getValue(for: .bpm)
        self.volume = UserDefaultsUtils.getValue(for: .volume)
        self.sourceType = UserDefaultsUtils.getValue(for: .sourceType)
        self.metronome = Metronome(bpm: _bpm, volume: _volume, sourceType: _sourceType)
        
        self.metronome.delegate = self
        
        self.addListener()
    }
    
    private func addListener() {
        sourceTypeSubject
             .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
             .sink { [weak self] newSource in
                 guard let self = self else { return }
                 self.metronome.changeSoundType(newSource)
                 UserDefaultsUtils.setValue(newSource, for: .sourceType)
             }
             .store(in: &cancellable)
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
        if newValue < 40 {
            self.bpm = 40
            return
        } else if newValue > 240 {
            self.bpm = 240
            return
        }
        self.bpm = newValue
        self.metronome.updateBPM(bpm: bpm)
        UserDefaultsUtils.setValue(bpm, for: .bpm)
    }

    func updateVolume(_ newValue: Double) {
        self.volume = newValue
        self.metronome.updateVolume(volume: volume)
        UserDefaultsUtils.setValue(volume, for: .volume)
    }
}

extension MetronomeControlViewModel: MetronomeDelegate {
    func audioInterruptionBegan() {
        isPlaying = false
        metronome.stop()
    }
    
    func audioInterruptionEnded(shouldResume: Bool) {
        isPlaying = shouldResume
        if shouldResume {
            metronome.start()
        } else {
            metronome.stop()
        }
    }
}
