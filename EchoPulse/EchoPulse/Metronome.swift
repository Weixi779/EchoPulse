//
//  Metronome.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/2/10.
//

import Foundation
import AVFoundation

final class Metronome {
    private var audioPlayer: AudioPlayer
    private var bpmTimer: Timer?
    var bpm: Double
    var volume: Double

    init(bpm: Double, volume: Double) {
        self.audioPlayer = AudioPlayer()
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
        guard let url = Bundle.main.url(forResource: "metronome", withExtension: "m4a") else {
            print("Error: Wrong Audio File URL")
            return
        }
        
        audioPlayer.prepareToPlay(url, volume)
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
        self.audioPlayer.setVolume(volume)
    }

    private func scheduleClick() {
        let interval = 60.0 / bpm
        bpmTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            self?.playAudio()
        }
    }

    private func playAudio() {
        self.audioPlayer.play()
    }
}
