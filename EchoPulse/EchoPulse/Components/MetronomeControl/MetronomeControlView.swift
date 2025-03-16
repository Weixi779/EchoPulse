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
                MetronomeControlToggleButton(
                    isPlaying: $viewModel.isPlaying,
                    onToggle: { viewModel.togglePlay() },
                    width: 244,
                    height: 120,
                    iconSize: 45,
                    cornerRadius: 20
                )
                
                HStack {
                    Text("BPM: \(String(format: "%.f", viewModel.bpm))")
                        .font(.headline)
                    
                    Stepper(value: $viewModel.bpm, step: 1) {
                        
                    } onEditingChanged: { editing in
                        if !editing {
                            viewModel.updateBPM(viewModel.bpm)
                        }
                    }
                }
                .padding()
                     
                MetronomeControlSlider(value: $viewModel.bpm, range: 40...240, step: 1) {
                    viewModel.updateBPM(viewModel.bpm)
                }
                
                Text("Volume: \(String(format: "%.f", viewModel.volume * 100)) %")
                    .font(.headline)
                
                MetronomeControlSlider(value: $viewModel.volume, range: 0.0...1.0, step: 0.1, multiplier: 100) {
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
