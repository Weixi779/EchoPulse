//
//  Metronome.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/2/10.
//

import Foundation
import AVFoundation

protocol MetronomeDelegate: AnyObject {
    func audioInterruptionBegan()
    func audioInterruptionEnded(shouldResume: Bool)
}

final class Metronome {
    private var player: MetronomePlayer
    private var sound: MetronomeSound
    
    weak var delegate: MetronomeDelegate?
    
    var bpm: Double
    var volume: Double

    init(bpm: Double, volume: Double, sourceType: MetronomeSourceType) {
        self.bpm = bpm
        self.volume = volume
        
        self.sound = .init(sourceType: sourceType)
        self.sound.adjustBufferForBPM(bpm: bpm)
        
        self.player = .init(buffer: self.sound.getBuffer()!)
        self.player.setVolume(volume)
        
        self.addObserver()
    }
    
    public func start() {
        player.play()
    }

    public func stop() {
        player.stop()
    }

    public func updateBPM(bpm: Double) {
        self.bpm = bpm
        self.sound.adjustBufferForBPM(bpm: bpm)
        if let buffer = self.sound.getBuffer() {
            self.player.updateBuffer(buffer: buffer)
        }
    }

    public func updateVolume(volume: Double) {
        self.volume = volume
        player.setVolume(volume)
    }

    public func changeSoundType(_ sourceType: MetronomeSourceType) {
        self.sound.updateSourceType(sourceType, self.bpm)
        if let buffer = self.sound.getBuffer() {
            self.player.updateBuffer(buffer: buffer)
        }
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleAudioSessionInterruption), name: AVAudioSession.interruptionNotification, object: nil)
    }
    
    @objc private func handleAudioSessionInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
            return
        }
        
        switch type {
        case .began:
            delegate?.audioInterruptionBegan()
        case .ended:
            let shouldResume: Bool
            if let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt {
                let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
                shouldResume = options.contains(.shouldResume)
            } else {
                shouldResume = false
            }
            
            delegate?.audioInterruptionEnded(shouldResume: shouldResume)
        @unknown default:
            break
        }
    }
}
