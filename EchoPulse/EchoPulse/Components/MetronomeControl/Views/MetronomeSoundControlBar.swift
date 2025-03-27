//
//  MetronomeSoundControlBar.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/2/10.
//

import SwiftUI

struct MetronomeSoundControlBar: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.schemeStyle) var schemeStyle
    
    @Binding var isPlaying: Bool
    var soundDataSource: SoundTypeDataSource
    var onToggle: () -> Void
    private let height: CGFloat
    private let cornerRadius: CGFloat = 20
    
    @State private var animationTrigger = false
    @State private var isShowingSoundSelection = false

    init(isPlaying: Binding<Bool>, soundDataSource: SoundTypeDataSource, onToggle: @escaping () -> Void, height: CGFloat) {
        self._isPlaying = isPlaying
        self.soundDataSource = soundDataSource
        self.onToggle = onToggle
        self.height = height
    }

    var body: some View {
        ZStack {
            glassBackground
            
            controlContent
        }
        .frame(height: height)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
        .animation(.easeInOut(duration: 0.3), value: isPlaying)
        .sheet(isPresented: $isShowingSoundSelection) {
            MetronomeSoundSelectionView(dataSource: soundDataSource)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
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
                        }
                }
                .transition(.opacity)
            }
        }
    }
    
    private var controlContent: some View {
        HStack(spacing: 16) {
            HStack {
                Image(systemName: soundDataSource.value.systemIconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: height * 0.4, height: height * 0.4)
                    .foregroundStyle(primaryColor.opacity(0.7))
                
                Divider()
                    .frame(height: height * 0.4)
                    .opacity(0.5)
                
                Text(soundDataSource.value.fileName)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .lineLimit(1)
                    .opacity(isPlaying ? 0.9 : 0.7)
                
                Image(systemName: "chevron.up.chevron.down")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .opacity(isPlaying ? 0.3 : 0.7)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                showSoundSelection()
            }
            
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
    
    private func showSoundSelection() {
          isShowingSoundSelection = true
    }
    
    var primaryColor: Color {
        return colorScheme.isDarkMode ? .white : .black
    }
}
