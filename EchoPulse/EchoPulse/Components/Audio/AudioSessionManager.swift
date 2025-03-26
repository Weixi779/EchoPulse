//
//  AudioSessionManager.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/3/26.
//

import Foundation
import AVFoundation
import os

protocol AudioSessionInterruptionDelegate: AnyObject {
    func audioInterruptionBegan()
    func audioInterruptionEnded(shouldResume: Bool)
}

final class AudioSessionManager {
    static let shared = AudioSessionManager()
    
    private var logger = Logger(subsystem: "Audio", category: "AudioSessionManager")
    private var delegates = NSHashTable<AnyObject>.weakObjects()
    
    private init() {
        setupNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func addDelegate(_ delegate: AudioSessionInterruptionDelegate) {
        delegates.add(delegate)
    }
    
    func removeDelegate(_ delegate: AudioSessionInterruptionDelegate) {
        delegates.remove(delegate)
    }
    
    func setupAudioSession(category: AVAudioSession.Category = .playback, options: AVAudioSession.CategoryOptions = [.mixWithOthers]) throws {
        do {
            try AVAudioSession.sharedInstance().setCategory(category, options: options)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            logger.error("Error setting up AVAudioSession: \(error.localizedDescription)")
            throw error
        }
    }
    
    private func setupNotifications() {
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
            for case let delegate as AudioSessionInterruptionDelegate in delegates.allObjects {
                delegate.audioInterruptionBegan()
            }
            
        case .ended:
            let shouldResume: Bool
            if let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt {
                let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
                shouldResume = options.contains(.shouldResume)
            } else {
                shouldResume = false
            }
            
            for case let delegate as AudioSessionInterruptionDelegate in delegates.allObjects {
                delegate.audioInterruptionEnded(shouldResume: shouldResume)
            }
            
        @unknown default:
            break
        }
    }
}
