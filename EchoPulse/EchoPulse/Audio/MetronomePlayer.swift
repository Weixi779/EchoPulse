//
//  AudioPlayer.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/2/10.
//

import Foundation
import AVFoundation
import os

final class MetronomePlayer {
    private var audioEngine = AVAudioEngine()
    private var playerNode = AVAudioPlayerNode()
    private var timePitch = AVAudioUnitTimePitch()
    private var audioBuffer: AVAudioPCMBuffer
    
    private var logger = Logger(subsystem: "Audio", category: "MetronomePlayer")

    init(buffer: AVAudioPCMBuffer) {
        self.audioBuffer = buffer
        setupAudioSession()
        setupAudioEngine()
        updateBuffer(buffer: buffer)
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            logger.error("Error setting up AVAudioSession: \(error.localizedDescription)")
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
            logger.error("Error starting audio engine: \(error.localizedDescription)")
        }
    }
    
    public func play() {
        if !playerNode.isPlaying {
            playerNode.play()
        }
    }

    public func stop() {
        if self.playerNode.isPlaying {
            playerNode.stop()
        }
    }

    public func setVolume(_ volume: Double) {
        audioEngine.mainMixerNode.outputVolume = Float(volume)
    }

    public func updateBuffer(buffer: AVAudioPCMBuffer) {
        self.audioBuffer = buffer
        self.updateScheduledBufferIfNeeded()
    }
    
    private func updateScheduledBufferIfNeeded() {
        if !self.playerNode.isPlaying {
            self.playerNode.scheduleBuffer(self.audioBuffer, at: nil, options: [.loops])
            return
        }
        
        playerNode.stop()
        playerNode.scheduleBuffer(self.audioBuffer, at: nil, options: [.loops])
        playerNode.play()
    }
}
