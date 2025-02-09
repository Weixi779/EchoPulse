//
//  MetronomeControlView.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/2/10.
//

import SwiftUI

struct MetronomeControlView: View {
    @State var isPlaying = false
    
    var body: some View {
        VStack {
            MetronomeToggleButton(
                isPlaying: $isPlaying,
                width: 244,
                height: 120,
                iconSize: 45,
                backgroundColor: .blue,
                cornerRadius: 20
            )
        }
    }
}

private struct MetronomeToggleButton: View {
    @Binding var isPlaying: Bool
    private let width: CGFloat
    private let height: CGFloat
    private let iconSize: CGFloat
    private let backgroundColor: Color
    private let cornerRadius: CGFloat
    
    init(isPlaying: Binding<Bool>, width: CGFloat, height: CGFloat, iconSize: CGFloat, backgroundColor: Color, cornerRadius: CGFloat) {
        self._isPlaying = isPlaying
        self.width = width
        self.height = height
        self.iconSize = iconSize
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        Button {
            isPlaying.toggle()
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

#Preview {
    MetronomeControlView()
}
