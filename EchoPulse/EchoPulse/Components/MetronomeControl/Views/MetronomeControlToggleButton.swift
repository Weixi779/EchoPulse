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
    
    @State private var animationTrigger = false
    @State private var pulseScale: CGFloat = 1.0

    init(isPlaying: Binding<Bool>, onToggle: @escaping () -> Void, height: CGFloat, cornerRadius: CGFloat) {
        self._isPlaying = isPlaying
        self.onToggle = onToggle
        self.height = height
        self.cornerRadius = cornerRadius
    }

    var body: some View {
        ZStack {
            glassBackground
            
            controlContent
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
    
    private var controlContent: some View {
        HStack(spacing: 16) {
            Image(systemName: "music.note")
                .resizable()
                .scaledToFit()
                .frame(width: height * 0.4, height: height * 0.4)
                .foregroundStyle(primaryColor.opacity(0.7))
            
            Divider()
                .frame(height: height * 0.4)
                .opacity(0.5)
            
            Spacer()
            
            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                .resizable()
                .frame(width: height * 0.3, height: height * 0.3)
                .foregroundStyle(primaryColor.opacity(0.7))
                .contentTransition(.symbolEffect(.replace))
                .symbolEffect(.bounce, options: .speed(1.5), value: animationTrigger)
                .onTapGesture {
                    onClickPlayback()
                }
        }
        .padding(.horizontal, 24)
    }
    
    private func onClickPlayback() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            onToggle()
        }
        
        animationTrigger.toggle()
    }
    
    var primaryColor: Color {
        return colorScheme.isDarkMode ? .white : .black
    }
}
