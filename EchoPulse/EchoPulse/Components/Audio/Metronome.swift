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
    func metronomeFailed(with error: Error)
    func metronomeStateChanged(to state: Metronome.State)
}

extension MetronomeDelegate {
    func metronomeFailed(with error: Error) {}
    func metronomeStateChanged(to state: Metronome.State) {}
}

final class Metronome {
    enum State {
        case stopped
        case playing
        case interrupted
    }
    
    enum MetronomeError: Error {
        case audioFileNotFound
        case audioBufferCreationFailed
        case audioEngineStartFailed
    }
    
    private var player: MetronomePlayer
    private var sound: MetronomeSound
    
    weak var delegate: MetronomeDelegate?
    
    var bpm: Double {
        didSet {
            if oldValue != bpm {
                updateBPM(bpm: bpm)
            }
        }
    }
    
    var volume: Double {
        didSet {
            if oldValue != volume {
                updateVolume(volume: volume)
            }
        }
    }
    
    var soundType: MetronomeSourceType {
        didSet {
            if oldValue != soundType {
                changeSoundType(soundType)
            }
        }
    }
    
    // 状态属性
    private(set) var state: State = .stopped {
        didSet {
            if oldValue != state {
                delegate?.metronomeStateChanged(to: state)
            }
        }
    }

    init(bpm: Double, volume: Double, sourceType: MetronomeSourceType) {
        self.bpm = bpm
        self.volume = volume
        self.soundType = sourceType
        
        self.sound = .init(sourceType: sourceType)
        self.sound.adjustBufferForBPM(bpm: bpm)
        
        guard let buffer = self.sound.getBuffer() else {
            fatalError("无法初始化音频缓冲区")
        }
        
        self.player = .init(buffer: buffer)
        self.player.setVolume(volume)
        
        self.addObserver()
    }
    
    public func start() {
        player.play()
        state = .playing
    }

    public func stop() {
        player.stop()
        state = .stopped
    }
    
    public func pause() {
        if state == .playing {
            player.stop()
            state = .stopped
        }
    }
    
    public func resume() {
        if state == .stopped {
            player.play()
            state = .playing
        }
    }
    
    public func toggle() {
        if state == .playing {
            stop()
        } else {
            start()
        }
    }

    private func updateBPM(bpm: Double) {
        self.sound.adjustBufferForBPM(bpm: bpm)
        if let buffer = self.sound.getBuffer() {
            self.player.updateBuffer(buffer: buffer)
        }
    }

    private func updateVolume(volume: Double) {
        player.setVolume(volume)
    }

    private func changeSoundType(_ sourceType: MetronomeSourceType) {
        self.sound.updateSourceType(sourceType, self.bpm)
        if let buffer = self.sound.getBuffer() {
            self.player.updateBuffer(buffer: buffer)
        }
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self,
                                              selector: #selector(handleAudioSessionInterruption),
                                              name: AVAudioSession.interruptionNotification,
                                              object: nil)
    }
    
    @objc private func handleAudioSessionInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
            return
        }
        
        switch type {
        case .began:
            let wasPlaying = state == .playing
            if wasPlaying {
                player.stop()
                state = .interrupted
            }
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
            
            if state == .interrupted && shouldResume {
                start()
            }
            
        @unknown default:
            break
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// 链式调用API扩展
extension Metronome {
    @discardableResult
    func setBPM(_ value: Double) -> Self {
        self.bpm = value
        return self
    }
    
    @discardableResult
    func setVolume(_ value: Double) -> Self {
        self.volume = value
        return self
    }
    
    @discardableResult
    func setSoundType(_ value: MetronomeSourceType) -> Self {
        self.soundType = value
        return self
    }
}
