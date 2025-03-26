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
    var bpmDataSource: BPMDataSource = .init()
    var volumeDataSource: VolumeDataSource = .init()
    var sourceTypeDataSource: SourceTypeDataSource = .init()
    
    var isPlaying = false
    private var metronome: MetronomeController
    private var cancellable = Set<AnyCancellable>()

    init() {
        self.metronome = MetronomeController(
            bpm: _bpmDataSource.value,
            volume: _volumeDataSource.value,
            soundType: _sourceTypeDataSource.value
        )
        
        self.addListeners()
    }
    
    private func addListeners() {
        self.addBPMCommitHooker()
        self.addVolumeCommitHooker()
        self.addSourceTypeCommitHooker()
    }
    
    private func addBPMCommitHooker() {
        bpmDataSource.valueCommitted
            .sink { bpm in
                self.metronome.setBPM(bpm)
            }
            .store(in: &cancellable)
    }
    
    private func addVolumeCommitHooker() {
        volumeDataSource.valueCommitted
            .sink { volume in
                self.metronome.setVolume(volume)
            }
            .store(in: &cancellable)
    }
    
    private func addSourceTypeCommitHooker() {
        sourceTypeDataSource.valueCommitted
            .sink { sourceType in
                self.metronome.setSoundType(sourceType)
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
