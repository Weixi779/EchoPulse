//
//  MetronomeToggleButton.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/2/10.
//

import SwiftUI

struct MetronomeControlToggleButton: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.schemeStyle) var schemeStyle
    
    @Binding var isPlaying: Bool
    var onToggle: () -> Void
    private let height: CGFloat
    private let cornerRadius: CGFloat
    
    @State private var pulseScale: CGFloat = 1.0

    init(isPlaying: Binding<Bool>, onToggle: @escaping () -> Void, height: CGFloat, cornerRadius: CGFloat) {
        self._isPlaying = isPlaying
        self.onToggle = onToggle
        self.height = height
        self.cornerRadius = cornerRadius
    }

    var body: some View {
        Button {
            onToggle()
        } label: {
            ZStack {
                glassBackground
                
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    .foregroundStyle(.white)
            }
        }
        .frame(height: height)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .animation(.easeInOut(duration: 0.3), value: isPlaying)
    }
    
    private var glassBackground: some View {
        ZStack {
            if !isPlaying {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
                    .overlay {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(schemeStyle.styleGradient(isDarkMode: colorScheme.isDarkMode), lineWidth: 1.5)
                    }
                    .transition(.opacity)
            } else {
                TimelineView(.animation(minimumInterval: 0.1, paused: !isPlaying)) { timeline in
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(.ultraThinMaterial)
                        .overlay {
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .stroke(
                                    schemeStyle.animatedStyleGradient(
                                        for: timeline.date,
                                        isDarkMode: colorScheme.isDarkMode
                                    ),
                                    lineWidth: 2.5
                                )
                                .scaleEffect(pulseScale)
                        }
                }
                .transition(.opacity)
            }
        }
    }
}
