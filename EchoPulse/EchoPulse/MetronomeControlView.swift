//
//  MetronomeControlView.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/2/10.
//

import SwiftUI

struct MetronomeControlView: View {
    @State private var isPlaying = false
    @State private var bpm: Double
    @State private var frequency: Double
    @State private var duration: Double
    @State private var volume: Double

    var metronome: Metronome

    init(metronome: Metronome = Metronome(bpm: 120, frequency: 1000, duration: 0.05, volume: 0.5)) {
        self.metronome = metronome
        _bpm = State(initialValue: metronome.bpm)
        _frequency = State(initialValue: metronome.frequency)
        _duration = State(initialValue: metronome.duration)
        _volume = State(initialValue: metronome.volume)
    }

    var body: some View {
        VStack(spacing: 20) {
            MetronomeToggleButton(
                isPlaying: $isPlaying,
                width: 244,
                height: 120,
                iconSize: 45,
                backgroundColor: .blue,
                cornerRadius: 20
            )
            .onChange(of: isPlaying) { newValue in
                if newValue {
                    metronome.start(bpm: bpm)
                } else {
                    metronome.stop()
                }
            }

            controlSlider(title: "BPM", value: $bpm, range: 40...240, step: 1) { newValue in
                if isPlaying {
                    metronome.updateBPM(bpm: newValue)
                }
            }

            controlSlider(title: "Frequency", value: $frequency, range: 200...5000, step: 50) { newValue in
                metronome.updateSound(frequency: newValue, duration: duration, volume: volume)
            }

            controlSlider(title: "Duration", value: $duration, range: 0.01...0.2, step: 0.01, multiplier: 1000, unit: "ms") { newValue in
                metronome.updateSound(frequency: frequency, duration: newValue, volume: volume)
            }

            controlSlider(title: "Volume", value: $volume, range: 0.0...1.0, step: 0.1, multiplier: 100, unit: "%") { newValue in
                metronome.updateSound(frequency: frequency, duration: duration, volume: newValue)
            }
        }
        .padding()
    }

    private func controlSlider(title: String, value: Binding<Double>, range: ClosedRange<Double>, step: Double, multiplier: Double = 1.0, unit: String = "", onChange: @escaping (Double) -> Void) -> some View {
        VStack {
            Text("\(title): \(Int(value.wrappedValue * multiplier)) \(unit)")
                .font(.headline)
            Slider(value: value, in: range, step: step)
                .padding(.horizontal)
                .onChange(of: value.wrappedValue, perform: onChange)
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
