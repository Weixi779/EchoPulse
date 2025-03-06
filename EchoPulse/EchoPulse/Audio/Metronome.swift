//
//  Metronome.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/2/10.
//

import Foundation
import AVFoundation

final class Metronome {
    private var player: MetronomePlayer
    private var sound: MetronomeSound
    
    var bpm: Double
    var volume: Double

    init(bpm: Double, volume: Double, sourceType: MetronomeSourceType) {
        self.bpm = bpm
        self.volume = volume
        
        self.sound = .init(sourceType: sourceType)
        self.sound.adjustBufferForBPM(bpm: bpm)
        
        self.player = .init(buffer: self.sound.getBuffer()!)
        self.player.setVolume(volume)
    }
    
    public func start() {
        player.play()
    }

    public func stop() {
        player.stop()
    }

    public func updateBPM(bpm: Double) {
        self.bpm = bpm
        self.sound.adjustBufferForBPM(bpm: bpm)
        if let buffer = self.sound.getBuffer() {
            self.player.updateBuffer(buffer: buffer)
        }
    }

    public func updateVolume(volume: Double) {
        self.volume = volume
        player.setVolume(volume)
    }

    public func changeSoundType(_ sourceType: MetronomeSourceType) {
        self.sound.updateSourceType(sourceType, self.bpm)
        if let buffer = self.sound.getBuffer() {
            self.player.updateBuffer(buffer: buffer)
        }
    }
}
