//
//  AudioPlayer.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/2/10.
//

import Foundation
import AVFoundation

final class MetronomePlayer {
    private var audioEngine = AVAudioEngine()
    private var playerNode = AVAudioPlayerNode()
    private var timePitch = AVAudioUnitTimePitch()
    private var audioBuffer: AVAudioPCMBuffer?

    init() {
        setupAudioSession()
        setupAudioEngine()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Error setting up AVAudioSession: \(error.localizedDescription)")
        }
    }

    private func setupAudioEngine() {
        audioEngine.attach(playerNode)
        audioEngine.attach(timePitch)
        audioEngine.connect(playerNode, to: timePitch, format: nil)
        audioEngine.connect(timePitch, to: audioEngine.mainMixerNode, format: nil)

        do {
            try audioEngine.start()
        } catch {
            print("Error starting audio engine: \(error.localizedDescription)")
        }
    }

    public func prepareToPlay(buffer: AVAudioPCMBuffer, volume: Double) {
        self.audioBuffer = buffer
        setVolume(volume)
    }

    public func play() {
        guard let buffer = audioBuffer else { return }
        playerNode.stop()
        playerNode.scheduleBuffer(buffer, at: nil, options: [.loops], completionHandler: nil)
        playerNode.play()
    }

    public func stop() {
        playerNode.stop()
    }

    public func setVolume(_ volume: Double) {
        audioEngine.mainMixerNode.outputVolume = Float(volume)
    }

    public func updateBuffer(buffer: AVAudioPCMBuffer) {
        audioBuffer = buffer
        playerNode.stop()
        playerNode.scheduleBuffer(buffer, at: nil, options: [.loops])
        playerNode.play()
    }
}
