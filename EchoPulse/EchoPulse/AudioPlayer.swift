//
//  AudioPlayer.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/2/10.
//

import Foundation
import AVFoundation

final class AudioPlayer {
    private var audioEngine = AVAudioEngine()
    private var playerNode = AVAudioPlayerNode()
    private var timePitch = AVAudioUnitTimePitch()  // 用于调整播放速率
    private var audioBuffer: AVAudioPCMBuffer?
    private let baseBPM: Double = 20  // 基准 BPM，基于 3 秒音频

    init() {
        setupAudioEngine()
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

    public func updateBPM(bpm: Double) {
        // 以 20 BPM 为基准，调整播放速率
        timePitch.rate = Float(bpm / baseBPM)
    }
    
    public func updateBuffer(for bpm: Double, originalBuffer: AVAudioPCMBuffer) {
        let baseBPM: Double = 20
        let targetDuration = (60.0 / bpm)
        let sampleRate = originalBuffer.format.sampleRate
        let totalFrames = AVAudioFrameCount(targetDuration * sampleRate)

        // 创建新的裁剪缓冲区
        guard let trimmedBuffer = AVAudioPCMBuffer(pcmFormat: originalBuffer.format, frameCapacity: totalFrames) else {
            print("Error creating trimmed buffer.")
            return
        }
        trimmedBuffer.frameLength = totalFrames

        // 复制数据到新的缓冲区
        if let source = originalBuffer.floatChannelData,
           let destination = trimmedBuffer.floatChannelData {
            for channel in 0..<Int(originalBuffer.format.channelCount) {
                memcpy(destination[channel], source[channel], Int(totalFrames) * MemoryLayout<Float>.size)
            }
        }

        // 更新播放缓冲
        audioBuffer = trimmedBuffer
        playerNode.stop()
        playerNode.scheduleBuffer(trimmedBuffer, at: nil, options: [.loops])
        playerNode.play()
    }
}
