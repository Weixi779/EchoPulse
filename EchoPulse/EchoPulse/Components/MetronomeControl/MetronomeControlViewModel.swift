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
    
    var bpmDataSource: BPMDataSource = .init()
    var volume: Double
    
    var isPlaying = false
    private var metronome: Metronome
    private var cancellable = Set<AnyCancellable>()

    init() {
        self.volume = UserDefaultsUtils.getValue(for: .volume)
        self.sourceType = UserDefaultsUtils.getValue(for: .sourceType)
        self.metronome = Metronome(bpm: _bpmDataSource.value, volume: _volume, sourceType: _sourceType)
        
        self.metronome.delegate = self
        
        self.addListener()
        self.addBPMCommitHooker()
    }
    
    private func addBPMCommitHooker() {
        bpmDataSource.valueCommitted
            .sink { bpm in
                self.metronome.updateBPM(bpm: bpm)
            }
            .store(in: &cancellable)
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
