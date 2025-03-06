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
    private var audioBuffer: AVAudioPCMBuffer?
    var bpm: Double
    var volume: Double

    init(bpm: Double, volume: Double) {
        self.player = .init()
        self.bpm = bpm
        self.volume = volume
        setupAudio()
    }

    private func setupAudio() {
        guard let url = Bundle.main.url(forResource: "Mechanical metronome - High", withExtension: "aif") else {
            print("Error: Wrong Audio File URL")
            return
        }

        do {
            let audioFile = try AVAudioFile(forReading: url)
            let format = audioFile.processingFormat
            let frameCount = AVAudioFrameCount(audioFile.length)
            audioBuffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount)
            try audioFile.read(into: audioBuffer!)

            player.prepareToPlay(buffer: audioBuffer!, volume: volume)
        } catch {
            print("Error loading audio file: \(error.localizedDescription)")
        }
    }

    func start(bpm: Double) {
        updateBPM(bpm: bpm)
        playAudio()
    }

    func stop() {
        player.stop()
    }

    func updateBPM(bpm: Double) {
        self.bpm = bpm
        guard let buffer = audioBuffer else { return }
        player.updateBuffer(for: bpm, originalBuffer: buffer)
    }

    func updateVolume(volume: Double) {
        self.volume = volume
        player.setVolume(volume)
    }

    private func playAudio() {
        guard audioBuffer != nil else {
            print("Error: Audio buffer is not loaded.")
            return
        }
        player.play()
    }
}
