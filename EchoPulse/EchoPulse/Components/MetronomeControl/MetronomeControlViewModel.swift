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
        let storageBPM = UDUtils.getValue(for: UDKeys.storageBPM)
        let storageVolume = UDUtils.getValue(for: UDKeys.storageVolume)
        let storageSourceType = UDUtils.getValue(for: UDKeys.storageSourceType)
        
        self.bpm = storageBPM
        self.volume = storageVolume
        self.sourceType = storageSourceType
        self.metronome = Metronome(bpm: storageBPM, volume: storageVolume, sourceType: storageSourceType)
        
        self.metronome.delegate = self
        
        self.addListener()
    }
    
    private func addListener() {
        sourceTypeSubject
             .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
             .sink { [weak self] newSource in
                 guard let self = self else { return }
                 self.metronome.changeSoundType(newSource)
                 UDUtils.setValue(newSource, for: UDKeys.storageSourceType)
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
        self.bpm = newValue
        self.metronome.updateBPM(bpm: bpm)
        UDUtils.setValue(bpm, for: UDKeys.storageBPM)
    }

    func updateVolume(_ newValue: Double) {
        self.volume = newValue
        self.metronome.updateVolume(volume: volume)
        UDUtils.setValue(volume, for: UDKeys.storageVolume)
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

extension UDKeys {
    static let storageBPM = UDKey<Double>("MetronomeControl.BPM", defaultValue: 120)
    static let storageVolume = UDKey<Double>("MetronomeControl.Volume", defaultValue: 0.5)
    static let storageSourceType = UDKey<MetronomeSourceType>("MetronomeControl.SourceType", defaultValue: .bassDrum)
}
