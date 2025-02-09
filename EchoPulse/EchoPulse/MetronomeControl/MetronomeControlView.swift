//
//  MetronomeControlView.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/2/10.
//

import SwiftUI

struct MetronomeControlView: View {
    @State private var viewModel = MetronomeControlViewModel()

    var body: some View {
        VStack(spacing: 20) {
            MetronomeControlToggleButton(
                isPlaying: $viewModel.isPlaying,
                onToggle: { viewModel.togglePlay() },
                width: 244,
                height: 120,
                iconSize: 45,
                backgroundColor: .blue,
                cornerRadius: 20
            )

            MetronomeControlSlider(title: "BPM", value: $viewModel.bpm, range: 40...240, step: 1) {
                viewModel.updateBPM(viewModel.bpm)
            }

            MetronomeControlSlider(title: "Frequency", value: $viewModel.frequency, range: 200...5000, step: 50) {
                viewModel.updateFrequency(viewModel.frequency)
            }

            MetronomeControlSlider(title: "Duration", value: $viewModel.duration, range: 0.01...0.2, step: 0.01, multiplier: 1000, unit: "ms") {
                viewModel.updateDuration(viewModel.duration)
            }

            MetronomeControlSlider(title: "Volume", value: $viewModel.volume, range: 0.0...1.0, step: 0.1, multiplier: 100, unit: "%") {
                viewModel.updateVolume(viewModel.volume)
            }
        }
        .padding()
    }
}

#Preview {
    MetronomeControlView()
}
