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
    var volumeDataSource: VolumeDataSource = .init()
    
    var isPlaying = false
    private var metronome: Metronome
    private var cancellable = Set<AnyCancellable>()

    init() {
        self.sourceType = UserDefaultsUtils.getValue(for: .sourceType)
        self.metronome = Metronome(bpm: _bpmDataSource.value, volume: _volumeDataSource.value, sourceType: _sourceType)
        
        self.metronome.delegate = self
        
        self.addListener()
        self.addBPMCommitHooker()
        self.addVolumeCommitHooker()
    }
    
    private func addBPMCommitHooker() {
        bpmDataSource.valueCommitted
            .sink { bpm in
                self.metronome.updateBPM(bpm: bpm)
            }
            .store(in: &cancellable)
    }
    
    private func addVolumeCommitHooker() {
        volumeDataSource.valueCommitted
            .sink { volume in
                self.metronome.updateVolume(volume: volume)
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
