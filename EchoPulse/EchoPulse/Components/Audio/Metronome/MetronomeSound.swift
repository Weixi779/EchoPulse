//
//  MetronomeSound.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/3/6.
//

import Foundation
import AVFoundation
import os

final class MetronomeSound {
    private var audioFile: AVAudioFile?
    private var originalBuffer: AVAudioPCMBuffer?
    private var audioBuffer: AVAudioPCMBuffer?
    private var soundType: MetronomeSoundType
    
    private let logger: Logger = Logger(subsystem: "Audio", category: "MetronomeSound")
    
    init(soundType: MetronomeSoundType) {
        self.soundType = soundType
        loadAudioFile()
    }
    
    public func getBuffer() -> AVAudioPCMBuffer? {
        return audioBuffer
    }

    public func updateSoundType(_ soundType: MetronomeSoundType, _ targetBPM: Double? = nil) {
        self.soundType = soundType
        loadAudioFile()
        
        if let bpm = targetBPM {
            self.adjustBufferForBPM(bpm: bpm)
        }
    }
    
    public func adjustBufferForBPM(bpm: Double) {
        guard let originalBuffer = originalBuffer else { return }

        let targetDuration = 60.0 / bpm
        let sampleRate = originalBuffer.format.sampleRate
        let totalFrames = AVAudioFrameCount(targetDuration * sampleRate)

        guard let trimmedBuffer = AVAudioPCMBuffer(pcmFormat: originalBuffer.format, frameCapacity: totalFrames) else {
            logger.error("Error creating trimmed buffer.")
            return
        }
        trimmedBuffer.frameLength = totalFrames

        if let source = originalBuffer.floatChannelData, let destination = trimmedBuffer.floatChannelData {
            let channelCount = Int(originalBuffer.format.channelCount)
            for channel in 0..<channelCount {
                let framesToCopy = min(Int(totalFrames), Int(originalBuffer.frameLength))
                memcpy(
                    destination[channel],
                    source[channel],
                    framesToCopy * MemoryLayout<Float>.size
                )
            }
        }

        self.audioBuffer = trimmedBuffer
    }
    
    private func loadAudioFile() {
        let fileName = soundType.fileName
        let fileType = soundType.fileType
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: fileType) else {
            logger.error("Error: Audio file \(fileName).\(fileType) not found")
            return
        }
        
        do {
            audioFile = try AVAudioFile(forReading: url)
            let format = audioFile!.processingFormat
            let frameCount = AVAudioFrameCount(audioFile!.length)
            originalBuffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount)
            try audioFile?.read(into: originalBuffer!)
        } catch {
            logger.error("Error loading audio file: \(error.localizedDescription)")
        }
    }
}
