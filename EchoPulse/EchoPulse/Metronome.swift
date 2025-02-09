//
//  Metronome.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/2/10.
//

import Foundation
import AVFoundation

final class Metronome {
    private var audioEngine = AVAudioEngine()
    private var playerNode = AVAudioPlayerNode()
    private var audioBuffer: AVAudioPCMBuffer?
    private var timer: Timer?
    var bpm: Double
    var frequency: Double
    var duration: Double
    var volume: Double

    init(bpm: Double = 120, frequency: Double = 1000, duration: Double = 0.05, volume: Double = 0.5) {
        self.bpm = bpm
        self.frequency = frequency
        self.duration = duration
        self.volume = volume
        setupAudio()
    }

    private func setupAudio() {
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.ambient, mode: .default, options: [.mixWithOthers])
        try? session.setActive(true)

        audioEngine.attach(playerNode)
        generateSound()

        let mixer = audioEngine.mainMixerNode
        audioEngine.connect(playerNode, to: mixer, format: audioBuffer?.format)
        try? audioEngine.start()
    }

    private func generateSound() {
        let format = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 1)
        let frameCount = AVAudioFrameCount(44100 * duration)
        audioBuffer = AVAudioPCMBuffer(pcmFormat: format!, frameCapacity: frameCount)
        audioBuffer?.frameLength = frameCount

        if let bufferPointer = audioBuffer?.floatChannelData {
            let buffer = bufferPointer[0]
            let sampleRate = Float(44100)
            let angularFrequency = 2.0 * .pi * Float(frequency) / sampleRate
            let volumeFactor = Float(volume)

            for i in 0..<Int(frameCount) {
                buffer[i] = sin(angularFrequency * Float(i)) * volumeFactor
            }
        }
    }

    func start(bpm: Double) {
        self.bpm = bpm
        stop()
        scheduleClick()
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        playerNode.stop()
    }

    func updateBPM(bpm: Double) {
        self.bpm = bpm
        if timer != nil {
            start(bpm: bpm)
        }
    }

    func updateSound(frequency: Double, duration: Double, volume: Double) {
        self.frequency = frequency
        self.duration = duration
        self.volume = volume
        generateSound()
    }

    private func scheduleClick() {
        let interval = 60.0 / bpm
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            self?.playClick()
        }
    }

    private func playClick() {
        guard let buffer = audioBuffer else { return }
        playerNode.scheduleBuffer(buffer, at: nil, options: [], completionHandler: nil)
        playerNode.play()
    }
}
