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
    private let width: CGFloat
    private let height: CGFloat
    private let iconSize: CGFloat
    private let cornerRadius: CGFloat

    init(isPlaying: Binding<Bool>, onToggle: @escaping () -> Void, width: CGFloat, height: CGFloat, iconSize: CGFloat, cornerRadius: CGFloat) {
        self._isPlaying = isPlaying
        self.onToggle = onToggle
        self.width = width
        self.height = height
        self.iconSize = iconSize
        self.cornerRadius = cornerRadius
    }

    var body: some View {
        Button {
            onToggle()
        } label: {
            ZStack {
                if !isPlaying {
                    schemeStyle
                        .styleGradient(isDarkMode: colorScheme.isDarkMode)
                        .transition(.opacity)
                } else {
                    TimelineView(.animation) { timeline in
                        schemeStyle.animatedStyleGradient(for: timeline.date, isDarkMode: colorScheme.isDarkMode)
                    }
                    .transition(.opacity)
                }
                
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    .resizable()
                    .frame(width: iconSize, height: iconSize)
                    .foregroundStyle(.white)
            }
        }
        .frame(width: width, height: height)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .animation(.easeInOut(duration: 0.3), value: isPlaying)
    }
}
