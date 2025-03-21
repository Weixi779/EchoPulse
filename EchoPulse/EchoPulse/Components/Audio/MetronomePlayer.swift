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
    private var isBufferScheduled = false
    
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
            // 确保每次播放前都重新调度缓冲区
            scheduleBuffer()
            playerNode.play()
        }
    }

    public func stop() {
        if self.playerNode.isPlaying {
            playerNode.stop()
            // 重置缓冲区调度状态
            isBufferScheduled = false
        }
    }

    public func setVolume(_ volume: Double) {
        audioEngine.mainMixerNode.outputVolume = Float(volume)
    }

    public func updateBuffer(buffer: AVAudioPCMBuffer) {
        self.audioBuffer = buffer
        
        // 如果播放器正在播放，需要更新调度的缓冲区
        if self.playerNode.isPlaying {
            updateScheduledBufferIfNeeded()
        } else {
            // 重置调度状态，但不立即调度
            isBufferScheduled = false
        }
    }
    
    private func scheduleBuffer() {
        playerNode.scheduleBuffer(self.audioBuffer, at: nil, options: [.loops])
        isBufferScheduled = true
    }
    
    private func updateScheduledBufferIfNeeded() {
        let needReplay = self.playerNode.isPlaying
        playerNode.stop()
        
        // 重新调度缓冲区
        scheduleBuffer()
        
        if needReplay {
            playerNode.play()
        }
    }
    
    deinit {
        playerNode.stop()
        audioEngine.stop()
    }
}
