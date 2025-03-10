//
//  MetronomeControlView.swift
//  EchoPulse
//
//  Created by 孙世伟 on 2025/2/10.
//

import SwiftUI

struct MetronomeControlView: View {
    @State private var viewModel = MetronomeControlViewModel()
    @State private var isShowMenu: Bool = false
    
    var body: some View {
        ZStack {
            MetronomeSoundPickerHeader(isShowMenu: $isShowMenu)
            
            VStack(spacing: 20) {
                HStack {
                    Image(systemName: "music.note")
                        .font(.largeTitle)
                        .foregroundStyle(.blue)
                    
                    Picker("Source", selection: $viewModel.sourceType) {
                        ForEach(MetronomeSourceType.allCases) { type in
                            Text(type.fileName)
                        }
                    }
                }
                
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
                
                MetronomeControlSlider(title: "Volume", value: $viewModel.volume, range: 0.0...1.0, step: 0.1, multiplier: 100, unit: "%") {
                    viewModel.updateVolume(viewModel.volume)
                }
            }
            .padding()
            
            MetronomeSideMenuView(isShowMenu: $isShowMenu, selectedSound: $viewModel.sourceType)
        }
    }
}

#Preview {
    MetronomeControlView()
}
