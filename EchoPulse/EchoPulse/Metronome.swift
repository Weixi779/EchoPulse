//
//  Metronome.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/2/10.
//

import Foundation
import AVFoundation

final class Metronome {
    private var audioPlayer: AVAudioPlayer?
    private var bpmTimer: Timer?
    var bpm: Double
    var volume: Double

    init(bpm: Double = 120, volume: Double = 0.5) {
        self.bpm = bpm
        self.volume = volume
        setupAudioSession()
        setupAudio()
    }

    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error setting up AVAudioSession: \(error.localizedDescription)")
        }
    }

    private func setupAudio() {
        if let url = Bundle.main.url(forResource: "metronome", withExtension: "m4a") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.prepareToPlay()
                audioPlayer?.volume = Float(volume)
            } catch {
                print("Error loading audio file: \(error.localizedDescription)")
            }
        }
    }

    func start(bpm: Double) {
        self.bpm = bpm
        bpmTimer?.invalidate()
        scheduleClick()
    }

    func stop() {
        bpmTimer?.invalidate()
        bpmTimer = nil
    }

    func updateBPM(bpm: Double) {
        self.bpm = bpm
        if bpmTimer != nil {
            start(bpm: bpm)
        }
    }

    func updateVolume(volume: Double) {
        self.volume = volume
        audioPlayer?.volume = Float(volume)
    }

    private func scheduleClick() {
        let interval = 60.0 / bpm
        bpmTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            self?.playClick()
        }
    }

    private func playClick() {
        audioPlayer?.currentTime = 0
        audioPlayer?.play()
    }
}
