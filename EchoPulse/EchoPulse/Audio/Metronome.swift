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
    
    private let baseBPM: Double = 20
    var bpm: Double
    var volume: Double

    init(bpm: Double, volume: Double) {
        self.player = .init()
        self.sound = .init(fileName: "Mechanical metronome - High", fileExtension: "aif")
        self.bpm = bpm
        self.volume = volume
        loadSound()
    }

    private func loadSound() {
        if let buffer = sound.getBuffer() {
            player.prepareToPlay(buffer: buffer, volume: volume)
        }
    }
    
    func start(bpm: Double) {
        updateBPM(bpm: bpm)
        player.play()
    }

    func stop() {
        player.stop()
    }

    func updateBPM(bpm: Double) {
        self.bpm = bpm
        self.sound.adjustBufferForBPM(bpm: bpm)
        if let buffer = self.sound.getBuffer() {
            self.player.updateBuffer(buffer: buffer)
        }
    }

    func updateVolume(volume: Double) {
        self.volume = volume
        player.setVolume(volume)
    }

    func changeSound(fileName: String, fileExtension: String) {
        sound.updateFile(fileName: fileName, fileExtension: fileExtension)
        loadSound()
        print("Updated metronome sound to \(fileName).\(fileExtension)")
    }
}
