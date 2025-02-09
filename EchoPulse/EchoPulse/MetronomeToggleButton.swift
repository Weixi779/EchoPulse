//
//  MetronomeToggleButton.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/2/10.
//

import SwiftUI

struct MetronomeToggleButton: View {
    @Binding var isPlaying: Bool
    var onToggle: () -> Void
    private let width: CGFloat
    private let height: CGFloat
    private let iconSize: CGFloat
    private let backgroundColor: Color
    private let cornerRadius: CGFloat

    init(isPlaying: Binding<Bool>, onToggle: @escaping () -> Void, width: CGFloat, height: CGFloat, iconSize: CGFloat, backgroundColor: Color, cornerRadius: CGFloat) {
        self._isPlaying = isPlaying
        self.onToggle = onToggle
        self.width = width
        self.height = height
        self.iconSize = iconSize
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
    }

    var body: some View {
        Button {
            onToggle()
        } label: {
            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                .resizable()
                .frame(width: iconSize, height: iconSize)
                .foregroundStyle(.white)
        }
        .frame(width: width, height: height)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}
