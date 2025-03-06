//
//  MetronomeSound.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/3/6.
//

import Foundation
import AVFoundation

final class MetronomeSound {
    private var audioFile: AVAudioFile?
    private var originalBuffer: AVAudioPCMBuffer?
    private var audioBuffer: AVAudioPCMBuffer?
    var fileName: String
    var fileExtension: String
    
    init(fileName: String, fileExtension: String) {
        self.fileName = fileName
        self.fileExtension = fileExtension
        loadAudioFile()
    }
    
    public func getBuffer() -> AVAudioPCMBuffer? {
        return audioBuffer
    }

    public func updateFile(fileName: String, fileExtension: String) {
        self.fileName = fileName
        self.fileExtension = fileExtension
        loadAudioFile()
    }
    
    public func adjustBufferForBPM(bpm: Double) {
        guard let originalBuffer = originalBuffer else { return }

        let targetDuration = 60.0 / bpm
        let sampleRate = originalBuffer.format.sampleRate
        let totalFrames = AVAudioFrameCount(targetDuration * sampleRate)

        guard let trimmedBuffer = AVAudioPCMBuffer(pcmFormat: originalBuffer.format, frameCapacity: totalFrames) else {
            print("Error creating trimmed buffer.")
            return
        }
        trimmedBuffer.frameLength = totalFrames

        if let source = originalBuffer.floatChannelData,
           let destination = trimmedBuffer.floatChannelData {
            for channel in 0..<Int(originalBuffer.format.channelCount) {
                memcpy(destination[channel], source[channel], Int(totalFrames) * MemoryLayout<Float>.size)
            }
        }

        self.audioBuffer = trimmedBuffer
    }
    
    private func loadAudioFile() {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else {
            print("Error: Audio file \(fileName).\(fileExtension) not found")
            return
        }
        
        do {
            audioFile = try AVAudioFile(forReading: url)
            let format = audioFile!.processingFormat
            let frameCount = AVAudioFrameCount(audioFile!.length)
            originalBuffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount)
            try audioFile?.read(into: originalBuffer!)
        } catch {
            print("Error loading audio file: \(error.localizedDescription)")
        }
    }
}
