//
//  Metronome.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/2/10.
//

import Foundation
import AVFoundation

final class MetronomeController {
    private var player: MetronomePlayer
    private var sound: MetronomeSound
    
    var bpm: Double {
        didSet {
            if oldValue != bpm {
                updateBPM(bpm: bpm)
            }
        }
    }
    
    var volume: Double {
        didSet {
            if oldValue != volume {
                updateVolume(volume: volume)
            }
        }
    }
    
    var soundType: MetronomeSoundType {
        didSet {
            if oldValue != soundType {
                changeSoundType(soundType)
            }
        }
    }

    init(bpm: Double, volume: Double, soundType: MetronomeSoundType) {
        self.bpm = bpm
        self.volume = volume
        self.soundType = soundType
        
        self.sound = .init(soundType: soundType)
        self.sound.adjustBufferForBPM(bpm: bpm)
        
        guard let buffer = self.sound.getBuffer() else {
            fatalError("无法初始化音频缓冲区")
        }
        
        self.player = .init(buffer: buffer)
        self.player.setVolume(volume)
    }
    
    deinit {
        player.stop()
    }
    
    public func start() {
        player.play()
    }

    public func stop() {
        player.stop()
    }
    
    public func toggle() {
        if player.isPlaying {
            stop()
        } else {
            start()
        }
    }

    private func updateBPM(bpm: Double) {
        self.sound.adjustBufferForBPM(bpm: bpm)
        if let buffer = self.sound.getBuffer() {
            self.player.updateBuffer(buffer: buffer)
        }
    }

    private func updateVolume(volume: Double) {
        player.setVolume(volume)
    }

    private func changeSoundType(_ soundType: MetronomeSoundType) {
        self.sound.updateSoundType(soundType, self.bpm)
        if let buffer = self.sound.getBuffer() {
            self.player.updateBuffer(buffer: buffer)
        }
    }
}

// 链式调用API扩展
extension MetronomeController {
    @discardableResult
    func setBPM(_ value: Double) -> Self {
        self.bpm = value
        return self
    }
    
    @discardableResult
    func setVolume(_ value: Double) -> Self {
        self.volume = value
        return self
    }
    
    @discardableResult
    func setSoundType(_ value: MetronomeSoundType) -> Self {
        self.soundType = value
        return self
    }
}
