//
//  AudioEngine.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/2/10.
//

import Foundation
import AVFoundation

final class AudioPlayer {
    
    private var player: AVAudioPlayer?
    
    init() { }
    
    public func prepareToPlay(_ fileURL: URL, _ volume: Double?) {
        do {
            self.player = try AVAudioPlayer(contentsOf: fileURL)
            self.player?.prepareToPlay()
            if let volume = volume {
                self.player?.volume = Float(volume)
            }
        } catch {
            print("Error loading audio file: \(error.localizedDescription)")
        }
    }
    
    public func play() {
        self.player?.currentTime = 0
        self.player?.play()
    }
    
    public func stop() {
        self.player?.stop()
        self.player?.prepareToPlay()
    }
    
    public func setVolume(_ volume: Double) {
        self.player?.volume = Float(volume)
    }
}
